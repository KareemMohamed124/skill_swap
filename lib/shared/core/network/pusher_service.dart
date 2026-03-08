import 'dart:convert';

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  static const String _appKey = 'e3ac92c762aaed1a23ae';
  static const String _cluster = 'mt1';

  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  final Map<String, bool> _subscribedChannels = {};
  String? _currentUserId;

  void Function(Map<String, dynamic> data)? onNewMessage;
  void Function(Map<String, dynamic> data)? onChatListUpdated;

  bool _isConnected = false;

  bool get isConnected => _isConnected;

  Future<void> init({required String userId}) async {
    if (_isConnected) return;

    _currentUserId = userId;

    await _pusher.init(
      apiKey: _appKey,
      cluster: _cluster,

      onConnectionStateChange: (current, previous) {
        print('🔌 [Pusher] state: $current');
      },

      onError: (message, code, error) {
        print('❌ [Pusher] error: $message');
      },

      onEvent: (event) {
        _handleEvent(event);
      },
    );

    await _pusher.connect();
    _isConnected = true;

    _subscribeToUserChannel(userId);
  }

  void _subscribeToUserChannel(String userId) async {
    final channelName = 'user-$userId';

    if (_subscribedChannels.containsKey(channelName)) return;

    await _pusher.subscribe(channelName: channelName);

    _subscribedChannels[channelName] = true;

    print('📡 [Pusher] Subscribed $channelName');
  }

  Future<void> subscribeToChatChannel(String chatId) async {
    final channelName = 'private-chat-$chatId';

    if (_subscribedChannels.containsKey(channelName)) return;

    await _pusher.subscribe(channelName: channelName);

    _subscribedChannels[channelName] = true;

    print('📡 [Pusher] Subscribed $channelName');
  }

  Future<void> unsubscribeFromChatChannel(String chatId) async {
    final channelName = 'private-chat-$chatId';

    if (!_subscribedChannels.containsKey(channelName)) return;

    await _pusher.unsubscribe(channelName: channelName);

    _subscribedChannels.remove(channelName);

    print('📡 [Pusher] Unsubscribed $channelName');
  }

  void _handleEvent(PusherEvent event) {
    if (event.data == null) return;

    try {
      final data = jsonDecode(event.data!);

      print(
        '📨 [Pusher] Event: ${event.eventName} channel: ${event.channelName}',
      );

      onNewMessage?.call(data);
      onChatListUpdated?.call(data);
    } catch (e) {
      print('❌ parse error $e');
    }
  }

  Future<void> disconnect() async {
    for (final channel in _subscribedChannels.keys) {
      await _pusher.unsubscribe(channelName: channel);
    }

    _subscribedChannels.clear();

    await _pusher.disconnect();

    _isConnected = false;
    _currentUserId = null;

    print('🔌 [Pusher] Disconnected');
  }
}
