import 'dart:async';
import 'dart:convert';
import 'package:pusher_client/pusher_client.dart';

/// Singleton service for Pusher real-time connections.
/// Handles subscribing to private chat channels and user channels.
class PusherService {
  static const String _appKey = 'e3ac92c762aaed1a23ae';
  static const String _cluster = 'mt1';

  PusherClient? _pusherClient;
  final Map<String, Channel> _subscribedChannels = {};
  String? _currentUserId;

  // Callbacks
  void Function(Map<String, dynamic> data)? onNewMessage;
  void Function(Map<String, dynamic> data)? onChatListUpdated;

  bool get isConnected => _pusherClient != null;

  /// Initialize and connect to Pusher
  Future<void> init({required String userId}) async {
    if (_pusherClient != null) {
      return; // Already initialized
    }
    _currentUserId = userId;

    try {
      _pusherClient = PusherClient(
        _appKey,
        PusherOptions(
          cluster: _cluster,
          encrypted: true,
        ),
        autoConnect: false,
        enableLogging: false,
      );

      _pusherClient!.onConnectionStateChange((state) {
        print('🔌 [Pusher] Connection state: ${state?.currentState}');
      });

      _pusherClient!.onConnectionError((error) {
        print('❌ [Pusher] Connection error: ${error?.message}');
        // Auto reconnect is handled by pusher_client internally
      });

      await _pusherClient!.connect();

      // Subscribe to user channel for chat list updates
      _subscribeToUserChannel(userId);
    } catch (e) {
      print('❌ [Pusher] Init error: $e');
    }
  }

  /// Subscribe to user-level channel for new chat notifications
  void _subscribeToUserChannel(String userId) {
    final channelName = 'user-$userId';
    if (_subscribedChannels.containsKey(channelName)) return;

    try {
      final channel = _pusherClient!.subscribe(channelName);

      channel.bind('new-message', (event) {
        _handleEvent(event);
      });

      channel.bind('message.sent', (event) {
        _handleEvent(event);
      });

      _subscribedChannels[channelName] = channel;
      print('📡 [Pusher] Subscribed to $channelName');
    } catch (e) {
      print('❌ [Pusher] Subscribe error ($channelName): $e');
    }
  }

  /// Subscribe to a specific private chat channel
  void subscribeToChatChannel(String chatId) {
    final channelName = 'private-chat-$chatId';
    if (_subscribedChannels.containsKey(channelName)) return;

    if (_pusherClient == null) {
      print('⚠️ [Pusher] Not initialized, cannot subscribe to $channelName');
      return;
    }

    try {
      final channel = _pusherClient!.subscribe(channelName);

      channel.bind('new-message', (event) {
        _handleEvent(event);
      });

      channel.bind('message.sent', (event) {
        _handleEvent(event);
      });

      _subscribedChannels[channelName] = channel;
      print('📡 [Pusher] Subscribed to $channelName');
    } catch (e) {
      print('❌ [Pusher] Subscribe error ($channelName): $e');
    }
  }

  /// Unsubscribe from a specific chat channel
  void unsubscribeFromChatChannel(String chatId) {
    final channelName = 'private-chat-$chatId';
    if (_subscribedChannels.containsKey(channelName)) {
      try {
        _pusherClient?.unsubscribe(channelName);
        _subscribedChannels.remove(channelName);
        print('📡 [Pusher] Unsubscribed from $channelName');
      } catch (e) {
        print('❌ [Pusher] Unsubscribe error ($channelName): $e');
      }
    }
  }

  void _handleEvent(PusherEvent? event) {
    if (event?.data == null) return;
    try {
      final data = jsonDecode(event!.data!) as Map<String, dynamic>;
      print(
          '📨 [Pusher] Event received: ${event.eventName} on ${event.channelName}');

      // Notify message listeners
      onNewMessage?.call(data);
      // Also notify chat list to update
      onChatListUpdated?.call(data);
    } catch (e) {
      print('❌ [Pusher] Parse event error: $e');
    }
  }

  /// Disconnect and clean up
  Future<void> disconnect() async {
    for (final channelName in _subscribedChannels.keys.toList()) {
      try {
        _pusherClient?.unsubscribe(channelName);
      } catch (_) {}
    }
    _subscribedChannels.clear();
    _pusherClient?.disconnect();
    _pusherClient = null;
    _currentUserId = null;
    onNewMessage = null;
    onChatListUpdated = null;
    print('🔌 [Pusher] Disconnected');
  }
}
