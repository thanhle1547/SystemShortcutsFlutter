import 'package:flutter/material.dart';
import 'package:system_shortcuts/system_shortcuts.dart' as system_shortcuts;

void main() => runApp(const Main());

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('System Shortcuts'),
        ),
        body: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Body();
  }
}

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        // ignore: always_specify_types
        children: [
          TextButton(
            child: const Text('Home'),
            onPressed: () async {
              await system_shortcuts.home();
            },
          ),
          TextButton(
            child: const Text('Back'),
            onPressed: () async {
              await system_shortcuts.back();
            },
          ),
          TextButton(
            child: const Text('VolDown'),
            onPressed: () async {
              await system_shortcuts.volDown();
            },
          ),
          TextButton(
            child: const Text('VolUp'),
            onPressed: () async {
              await system_shortcuts.volUp();
            },
          ),
          TextButton(
            child: const Text('Landscape'),
            onPressed: () async {
              await system_shortcuts.orientLandscape();
            },
          ),
          TextButton(
            child: const Text('Portrait'),
            onPressed: () async {
              await system_shortcuts.orientPortrait();
            },
          ),
          TextButton(
            child: const Text('Wifi'),
            onPressed: () async {
              await system_shortcuts.wifi();
            },
          ),
          TextButton(
            child: const Text('Check Wifi'),
            onPressed: () async {
              final bool? result = await system_shortcuts.checkWifi;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Wifi Turned On Check - $result'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          TextButton(
            child: const Text('Bluetooth'),
            onPressed: () async {
              await system_shortcuts.bluetooth();
            },
          ),
          TextButton(
            child: const Text('Check Bluetooth'),
            onPressed: () async {
              final bool? result = await system_shortcuts.checkBluetooth;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Bluetooth Turned On Check - $result'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
