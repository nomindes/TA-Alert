import 'package:flutter/material.dart';
import 'package:tadaikoukun/screens/settings.dart';
import 'package:tadaikoukun/theme.dart';
import 'package:tadaikoukun/utils/audio_handler.dart';
import 'package:tadaikoukun/utils/permission_handler.dart';
import 'package:tadaikoukun/utils/slack_notifier.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double _volume = 0.0;
  bool _isListening = false;
  bool _microphonePermissionGranted = false;
  final MicrophonePermissionsHandler _permissionsHandler = MicrophonePermissionsHandler();
  late SlackNotifier _slackNotifier;

  @override
  void initState() {
    super.initState();
    _checkMicrophonePermission();
    _slackNotifier = SlackNotifier(
      webhookUrl: 'https://hooks.slack.com/services/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',
      threshold: 70.0, // 閾値を70 dBに設定
    );
  }

  Future<void> _checkMicrophonePermission() async {
    final isGranted = await _permissionsHandler.isGranted;
    setState(() {
      _microphonePermissionGranted = isGranted;
    });
    if (!isGranted) {
      _showPermissionDialog();
    } else {
      _startListening();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('マイクの権限が必要です'),
          content: const Text('アプリの機能を使用するには、マイクの権限が必要です。設定画面で権限を許可してください。'),
          actions: <Widget>[
            TextButton(
              child: const Text('設定'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen(
                    onMicrophonePermissionChanged: _handleMicrophonePermissionChanged,
                    initialMicrophonePermission: _microphonePermissionGranted,
                  )),
                ).then((_) => _checkMicrophonePermission());
              },
            ),
          ],
        );
      },
    );
  }

  void _startListening() {
    if (_microphonePermissionGranted && !_isListening) {
      AudioHandler.startListening();
      AudioHandler.volumeStream.listen((volume) {
        setState(() {
          _volume = volume;
        });
        _slackNotifier.checkAndNotify(volume);
      });
      setState(() {
        _isListening = true;
      });
    }
  }

  void _stopListening() {
    if (_isListening) {
      AudioHandler.stopListening();
      setState(() {
        _isListening = false;
        _volume = 0.0;
      });
    }
  }

  void _handleMicrophonePermissionChanged(bool isGranted) {
    setState(() {
      _microphonePermissionGranted = isGranted;
    });
    if (isGranted) {
      _startListening();
    } else {
      _stopListening();
    }
  }

  @override
  void dispose() {
    AudioHandler.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: MaterialTheme.lightScheme().surfaceContainer,
          elevation: 0,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text('TA代行くん', style: TextStyle(fontSize: 16)),
          ),
          leading: const Icon(Icons.note),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen(
                    onMicrophonePermissionChanged: _handleMicrophonePermissionChanged,
                    initialMicrophonePermission: _microphonePermissionGranted,
                  )),
                );
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(50, 100, 0, 0),
              child: Row(
                children: [
                  SizedBox(width: 8),
                  Text(
                    '○教室',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 50, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: _isListening ? _volume / 100 : 0,
                    backgroundColor: MaterialTheme.lightScheme().primaryContainer,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        MaterialTheme.lightScheme().primary),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _isListening ? '${_volume.toStringAsFixed(1)} dB' : '0.0 dB',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}