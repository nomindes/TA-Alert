import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

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
              title: const Text('音声'),
              value: true,
              onChanged: (bool value) {},
            ),
            const SizedBox(height: 20),
            const Text('クレジット',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildCreditItem('Sena(Coding)', 'https://nomindev.net/'),
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
