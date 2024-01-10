import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoPage extends StatefulWidget {
  const MemoPage({super.key});

  @override
  State<StatefulWidget> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> _memoList = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadMemoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memo Page')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'input here',
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
                child: ListView.builder(
                    itemCount: _memoList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = _memoList[index];
                      final dispIndex = index + 1;
                      return Card(
                        child: InkWell(
                          onTap: () => _onTapCardItem(index),
                          child: ListTile(
                            title: Text("$dispIndex : $item"),
                            contentPadding: const EdgeInsets.all(8),
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () => _onPressedAddItemButton(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () => _onPressedDeleteItemsButton(),
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _onTapCardItem(int index) async {
    final dispIndex = index + 1;
    final SharedPreferences prefs = await _prefs;

    _showAlertDialog(
        title: "削除しますか？",
        message: "$dispIndex番目のアイテムを削除します",
        onPositiveButton: () async {
          _memoList.removeAt(index);
          await prefs.setStringList('MemoList', _memoList);
          final updatedList = prefs.getStringList('MemoList') ?? [];
          setState(() {
            _memoList = updatedList;
          });
        },
        onNegativeButton: () {
          _showSnackBar(message: "処理をキャンセルしました");
        });
  }

  Future<void> _onPressedAddItemButton() async {
    final newMemo = _textEditingController.text;
    final SharedPreferences prefs = await _prefs;
    if (newMemo.isEmpty) {
      _showSnackBar(message: "文字を入力してください");
      return;
    }

    // リストを更新
    _memoList.add(newMemo);
    await prefs.setStringList('MemoList', _memoList);
    final updatedList = prefs.getStringList('MemoList') ?? [];

    setState(() {
      _memoList = updatedList;
    });
  }

  Future<void> _onPressedDeleteItemsButton() async {
    final SharedPreferences prefs = await _prefs;

    _showAlertDialog(
        title: "削除しますか？",
        message: "全部のアイテムを削除します",
        onPositiveButton: () async {
          _memoList = [];
          await prefs.setStringList('MemoList', _memoList);
          final updatedList = prefs.getStringList('MemoList') ?? [];
          setState(() {
            _memoList = updatedList;
          });
        },
        onNegativeButton: () {
          _showSnackBar(message: "処理をキャンセルしました");
        }
    );
  }

  void _showSnackBar({required String message}) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _loadMemoList() async {
    final SharedPreferences prefs = await _prefs;
    final List<String> loadedMemoList = prefs.getStringList('MemoList') ?? [];
    setState(() {
      _memoList = loadedMemoList;
    });
  }

  Future<void> _showAlertDialog(
      {required String title,
      required String message,
      required Function onPositiveButton,
      required Function onNegativeButton}) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                onNegativeButton();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Yes'),
              onPressed: () {
                onPositiveButton();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
