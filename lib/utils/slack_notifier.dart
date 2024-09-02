import 'dart:convert';
import 'package:http/http.dart' as http;

class SlackNotifier {
  final String webhookUrl;
  final double threshold;
  bool _hasNotified = false;

  SlackNotifier({required this.webhookUrl, required this.threshold});

  Future<void> checkAndNotify(double volume) async {
    if (volume >= threshold && !_hasNotified) {
      await _sendSlackNotification(volume);
      _hasNotified = true;
    } else if (volume < threshold) {
      _hasNotified = false;
    }
  }

  Future<void> _sendSlackNotification(double volume) async {
    final message = {
      'text': '警告: 音量が閾値を超えました！\n現在の音量: ${volume.toStringAsFixed(1)} dB'
    };

    // thingproxy.freeboard.ioを使用してリクエストを送信
    final proxyUrl = 'https://thingproxy.freeboard.io/fetch/';
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
        print('Slack通知の送信に失敗しました: ${response.statusCode}');
        print('レスポンス: ${response.body}');
      } else {
        print('Slack通知を送信しました');
      }
    } catch (e) {
      print('Slack通知の送信中にエラーが発生しました: $e');
    }
  }
}