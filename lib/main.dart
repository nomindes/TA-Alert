import 'package:flutter/material.dart';
import 'package:tadaikoukun/screens/home.dart';
import 'package:tadaikoukun/theme.dart';
import 'package:tadaikoukun/utils/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const TAdaikoukun());
}

class TAdaikoukun extends StatefulWidget {
  const TAdaikoukun({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TAdaikoukunState createState() => _TAdaikoukunState();
}

class _TAdaikoukunState extends State<TAdaikoukun> {
  final MicrophonePermissionsHandler _permissionsHandler =
      MicrophonePermissionsHandler();

  @override
  void initState() {
    super.initState();
    _checkMicrophonePermission();
  }

  Future<void> _checkMicrophonePermission() async {
    final isGranted = await _permissionsHandler.isGranted;
    if (!isGranted) {
      // 権限がない場合は、MyAppウィジェットで処理します
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TA Alert",
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: MaterialTheme.lightScheme().toColorScheme()),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: MaterialTheme.lightScheme().toColorScheme(),
      ),
      home: const MyApp(),
    );
  }
}
