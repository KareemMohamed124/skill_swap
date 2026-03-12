import 'dart:async';
import 'dart:convert';

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  static const String _appKey = 'e3ac92c762aaed1a23ae';
  static const String _cluster = 'mt1';

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  final Map<String, bool> _subscribedChannels = {};
  String? _currentUserId;

  final StreamController<Map<String, dynamic>> _messageController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  bool _isConnected = false;
  bool _isConnecting = false;

  final List<String> _pendingSubscriptions = [];
  Completer<void>? _connectionCompleter;

  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectBaseDelay = Duration(seconds: 2);
  int _reconnectAttempts = 0;
  Timer? _reconnectTimer;

  // ================= INIT CONNECTION =================
  Future<void> init({required String userId}) async {
    if (_isConnected || _isConnecting) return;

    _isConnecting = true;
    _currentUserId = userId;
    _connectionCompleter = Completer<void>();

    try {
      await _pusher.init(
        apiKey: _appKey,
        cluster: _cluster,
        onConnectionStateChange: (current, previous) {
          _handleConnectionStateChange(current.toString(), previous.toString());
        },
        onError: (message, code, error) {
          print('❌ [Pusher] error: $message (code: $code)');
        },
        onEvent: (event) {
          _handleEvent(event);
        },
      );

      await _pusher.connect();
      _isConnected = true;
      _isConnecting = false;
      _reconnectAttempts = 0;

      _subscribeToUserChannel(userId);
      await _processPendingSubscriptions();

      if (!_connectionCompleter!.isCompleted) {
        _connectionCompleter!.complete();
      }

      print('✅ [Pusher] Connected for user $userId');
    } catch (e) {
      _isConnecting = false;
      if (_connectionCompleter != null && !_connectionCompleter!.isCompleted) {
        _connectionCompleter!.completeError(e);
      }
      print('❌ [Pusher] Failed to init: $e');
      _scheduleReconnect();
    }
  }

  Future<void> get whenConnected {
    if (_isConnected) return Future.value();
    return _connectionCompleter?.future ?? Future.value();
  }

  // ================= CONNECTION STATE HANDLER =================
  void _handleConnectionStateChange(String current, String previous) {
    final lowerCurrent = current.toLowerCase();

    if (lowerCurrent == 'connected') {
      _isConnected = true;
      _isConnecting = false;
      _reconnectAttempts = 0;
      _reconnectTimer?.cancel();
      print('✅ [Pusher] Reconnected');
    } else if (lowerCurrent == 'disconnected' ||
        lowerCurrent == 'reconnecting') {
      _isConnected = false;
      if (lowerCurrent == 'disconnected' && _currentUserId != null) {
        _scheduleReconnect();
      }
    }
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      print('❌ [Pusher] Max reconnect attempts reached');
      return;
    }

    _reconnectTimer?.cancel();
    final delay = _reconnectBaseDelay * (1 << _reconnectAttempts);
    _reconnectAttempts++;

    print(
        '🔄 [Pusher] Reconnecting in ${delay.inSeconds}s (attempt $_reconnectAttempts)');

    _reconnectTimer = Timer(delay, () async {
      if (_isConnected || _isConnecting) return;
      _isConnecting = true;
      try {
        await _pusher.connect();
        _isConnected = true;
        _isConnecting = false;
        _reconnectAttempts = 0;

        final channels = Map<String, bool>.from(_subscribedChannels);
        _subscribedChannels.clear();
        for (final channel in channels.keys) {
          await _pusher.subscribe(channelName: channel);
          _subscribedChannels[channel] = true;
          print('📡 [Pusher] Re-subscribed to $channel');
        }

        await _processPendingSubscriptions();
      } catch (e) {
        _isConnecting = false;
        print('❌ [Pusher] Reconnect failed: $e');
        _scheduleReconnect();
      }
    });
  }

  Future<void> _processPendingSubscriptions() async {
    final pending = List<String>.from(_pendingSubscriptions);
    _pendingSubscriptions.clear();

    for (final channelName in pending) {
      if (_subscribedChannels.containsKey(channelName)) continue;

      try {
        await _pusher.subscribe(channelName: channelName);
        _subscribedChannels[channelName] = true;
        print('📡 [Pusher] Subscribed to (queued) $channelName');
      } catch (e) {
        print('❌ [Pusher] Failed to subscribe to $channelName: $e');
      }
    }
  }

  // ================= USER CHANNEL =================
  void _subscribeToUserChannel(String userId) async {
    final channelName = 'user-$userId';
    if (_subscribedChannels.containsKey(channelName)) return;

    await _pusher.subscribe(channelName: channelName);
    _subscribedChannels[channelName] = true;
    print('📡 [Pusher] Subscribed to $channelName');
  }

  // ================= CHAT CHANNELS =================
  Future<void> subscribeToChat({
    required String chatId,
    required String currentUserId,
    bool isPrivate = false,
    String? partnerId,
  }) async {
    String channelName;
    if (isPrivate) {
      if (partnerId == null)
        throw Exception("partnerId required for private chat");
      final ids = [currentUserId, partnerId]..sort();
      channelName = 'private_${ids[0]}_${ids[1]}';
    } else {
      // هنا الاسم متطابق مع الباك
      channelName = chatId;
    }

    if (!_subscribedChannels.containsKey(channelName)) {
      if (!_isConnected) {
        if (!_pendingSubscriptions.contains(channelName))
          _pendingSubscriptions.add(channelName);
        return;
      }

      await _pusher.subscribe(channelName: channelName);
      _subscribedChannels[channelName] = true;
      print('📡 [Pusher] Subscribed to $channelName');
    }
  }

  Future<void> unsubscribeFromChat(String chatId,
      {bool isPrivate = false,
      String? partnerId,
      required String currentUserId}) async {
    String channelName;
    if (isPrivate) {
      if (partnerId == null) return;
      final ids = [currentUserId, partnerId]..sort();
      channelName = 'private_${ids[0]}_${ids[1]}';
    } else {
      channelName = chatId; // نفس الاسم
    }

    _pendingSubscriptions.remove(channelName);

    if (_subscribedChannels.containsKey(channelName)) {
      await _pusher.unsubscribe(channelName: channelName);
      _subscribedChannels.remove(channelName);
      print('📡 [Pusher] Unsubscribed from $channelName');
    }
  }

  // ================= EVENT HANDLER =================
  void _handleEvent(PusherEvent event) {
    if (event.data == null) return;
    if (event.eventName != 'receive_message') return;

    try {
      final data = jsonDecode(event.data!);
      data['_pusherChannel'] = event.channelName;
      _messageController.add(data);

      print(
          '📨 [Pusher] Event: ${event.eventName} channel: ${event.channelName} data: $data');
    } catch (e) {
      print('❌ [Pusher] parse error $e');
    }
  }

  // ================= DISCONNECT =================
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _pendingSubscriptions.clear();

    for (final channel in _subscribedChannels.keys) {
      await _pusher.unsubscribe(channelName: channel);
    }

    _subscribedChannels.clear();

    await _pusher.disconnect();

    _isConnected = false;
    _isConnecting = false;
    _currentUserId = null;
    _reconnectAttempts = 0;

    print('🔌 [Pusher] Disconnected');
  }

  void dispose() {
    _reconnectTimer?.cancel();
    _messageController.close();
  }
}

// Singleton instance
final pusherService = PusherService();
