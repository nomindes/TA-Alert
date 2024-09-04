import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SlackNotifier {
  final String webhookUrl;
  final double threshold;
  bool _isCurrentlyAboveThreshold = false;
  DateTime? _lastNotificationTime;
  bool _isNotificationInProgress = false;

  SlackNotifier({required this.webhookUrl, required this.threshold});

  Future<void> checkAndNotify(double volume) async {
    final now = DateTime.now();

    if (volume >= threshold) {
      if (!_isCurrentlyAboveThreshold) {
        _isCurrentlyAboveThreshold = true;
        await _trySendNotification(volume, now);
      } else if (_canSendNotification(now)) {
        await _trySendNotification(volume, now);
      }
    } else {
      _isCurrentlyAboveThreshold = false;
    }
  }

  bool _canSendNotification(DateTime now) {
    if (_lastNotificationTime == null) return true;
    return now.difference(_lastNotificationTime!) >= const Duration(minutes: 5);
  }

  Future<void> _trySendNotification(double volume, DateTime now) async {
    if (!_isNotificationInProgress) {
      _isNotificationInProgress = true;
      await _sendSlackNotification(volume);
      _lastNotificationTime = now;
      _isNotificationInProgress = false;
    }
  }

  Future<void> _sendSlackNotification(double volume) async {
    final message = {
      'text': '警告: 音量が閾値 ${threshold.toStringAsFixed(1)} dBを超えています！\n'
          '現在の音量: ${volume.toStringAsFixed(1)} dB'
    };

    const proxyUrl = 'https://thingproxy.freeboard.io/fetch/';
    final fullUrl = proxyUrl + webhookUrl;

    try {
      final response = await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(message),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 200) {
        if (kDebugMode) {
          print('Slack通知の送信に失敗しました: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('レスポンス: ${response.body}');
        }
      } else {
        if (kDebugMode) {
          print('Slack通知を送信しました: ${message['text']}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Slack通知の送信中にエラーが発生しました: $e');
      }
    }
  }
}
