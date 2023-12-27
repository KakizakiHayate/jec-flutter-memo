import 'package:flutter/material.dart';
import 'package:my_flutter_memo_app/memo_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: Text('home page')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(child: Text('Welcome Flutter Memo App')),
            ListTile(
              leading: const Icon(Icons.message),
              title: const Text('memo page'),
              onTap: () {
                Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => const MemoPage()));
              },
            )
          ],
        ),
      ),
    );
  }
}