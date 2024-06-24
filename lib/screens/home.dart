import 'package:flutter/material.dart';
import 'package:tadaikoukun/screens/settings.dart';
import 'package:tadaikoukun/theme.dart';

class MyApp extends StatelessWidget {
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
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text('TA代行くん', style: TextStyle(fontSize: 16)),
          ),
          leading: Icon(Icons.note),
          actions: [
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(50, 100, 0, 0),
              child: Row(
                children: [
                  SizedBox(width: 8),
                  Text(
                    '○教室',
                    style:
                        TextStyle(fontSize: 40, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor:
                        MaterialTheme.lightScheme().primaryContainer,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        MaterialTheme.lightScheme().primary),
                    minHeight: 8,
                  ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '○○%',
                      style: TextStyle(fontSize: 16),
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
