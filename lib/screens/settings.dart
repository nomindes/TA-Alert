// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tadaikoukun/utils/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onMicrophonePermissionChanged;
  final bool initialMicrophonePermission;

  const SettingsScreen({
    Key? key, 
    required this.onMicrophonePermissionChanged,
    required this.initialMicrophonePermission,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _microphonePermissionGranted;
  final MicrophonePermissionsHandler _permissionsHandler = MicrophonePermissionsHandler();

  @override
  void initState() {
    super.initState();
    _microphonePermissionGranted = widget.initialMicrophonePermission;
  }

  Future<void> _handleMicrophonePermission(bool value) async {
    if (value) {
      final status = await _permissionsHandler.request();
      setState(() {
        _microphonePermissionGranted = status == MicrophonePermissionStatus.granted;
      });

      switch (status) {
        case MicrophonePermissionStatus.granted:
          // ignore: duplicate_ignore
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('マイクの使用が許可されました')),
          );
          break;
        case MicrophonePermissionStatus.denied:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('マイクの使用が拒否されました')),
          );
          break;
        case MicrophonePermissionStatus.prompt:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('次回、マイクの使用時に再度許可を求められます')),
          );
          break;
        case MicrophonePermissionStatus.notSupported:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('このブラウザではマイクの使用がサポートされていません')),
          );
          break;
      }
    } else {
      setState(() {
        _microphonePermissionGranted = false;
      });
    }
    widget.onMicrophonePermissionChanged(_microphonePermissionGranted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('設定', style: TextStyle(fontSize: 24)),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('言語',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            RadioListTile(
              title: const Text('日本語'),
              value: 'japanese',
              groupValue: 'japanese',
              onChanged: (value) {},
            ),
            RadioListTile(
              title: const Text('English'),
              value: 'english',
              groupValue: 'japanese',
              onChanged: (value) {},
            ),
            const SizedBox(height: 20),
            const Text('権限',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SwitchListTile(
              title: const Text('マイク'),
              value: _microphonePermissionGranted,
              onChanged: _handleMicrophonePermission,
            ),
            const SizedBox(height: 20),
            const Text('クレジット',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildCreditItem('Sena(Coding)', 'https://nomin.jp'),
            _buildCreditItem('Daigo(AL授業免除乱用)', 'https://youtube.com/@tdm22/'),
            _buildCreditItem('Tomo(Design)', 'https://linktr.ee/utawaka0001'),
            _buildCreditItem('Eito(Design)', 'https://instagram.com/s4_waei/'),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditItem(String name, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          if (url.isNotEmpty)
            GestureDetector(
              onTap: () => _launchURL(url),
              child: Text(url, style: const TextStyle(color: Colors.blue)),
            ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
