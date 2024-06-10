import 'package:flutter/material.dart';
import 'package:tadaikoukun/screens/settings.dart';
import 'package:tadaikoukun/theme.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: Icon(Icons.menu)),
          backgroundColor: MaterialTheme.lightScheme().surfaceContainer,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("TA代行くん"),
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("○教室"), Text("Switch")],
            ),
            Text("aaa")
          ],
        ));
  }
}
