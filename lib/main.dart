import 'package:flutter/material.dart';
import 'package:tadaikoukun/screens/home.dart';
import 'package:tadaikoukun/theme.dart';
import 'package:tadaikoukun/utils/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const TAAlert());
}

class TAAlert extends StatefulWidget {
  const TAAlert({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TAAlertState createState() => _TAAlertState();
}

class _TAAlertState extends State<TAAlert> {
  final MicrophonePermissionsHandler _permissionsHandler =
      MicrophonePermissionsHandler();

  @override
  void initState() {
    super.initState();
    _checkMicrophonePermission();
  }

  Future<void> _checkMicrophonePermission() async {
    final isGranted = await _permissionsHandler.isGranted;
    if (!isGranted) {}
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
