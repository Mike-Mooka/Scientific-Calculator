import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'history_model.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late List<HistoryItem> _items = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  _loadHistory() async {
    List<HistoryItem> items = await DatabaseHelper.instance.queryAllHistory();
    setState(() {
      _items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_items[index].expression),
          subtitle: Text(_items[index].result),
        );
      },
    );
  }
}
