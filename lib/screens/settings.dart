import 'package:flutter/material.dart';
import 'package:tadaikoukun/theme.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          backgroundColor: MaterialTheme.lightScheme().background,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("設定"),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Settings()));
                },
                icon: Icon(Icons.settings))
          ],
        ),
      ),
      body: Column(
        children: [Text("言語")],
      ),
    );
  }
}
