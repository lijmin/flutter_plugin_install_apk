import 'package:flutter/material.dart';

import 'package:install_apk/install_apk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _installApkPlugin = InstallApk();
  String filePath = "/data/user/0/com.example.install_apk_example/files/example.apk";

  @override
  void initState() {
    super.initState();
  }

  installApk() async {
    Map resp = await _installApkPlugin.installApk(filePath);
    print(resp.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('install apk'),
        ),
        body: Column(
          children: [
            Text('apk path: $filePath\n'),
            OutlinedButton(onPressed: ()=>installApk(), child: const Text("install apk")),
          ],
        ),
      ),
    );
  }
}
