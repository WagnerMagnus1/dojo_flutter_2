import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> items = [];
  TextEditingController controller = TextEditingController();
  SharedPreferences? prefs;
  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  _loadItems() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      items = prefs?.getStringList('items') ?? [];
    });
  }

  _addItem(String item) async {
    if (item.isNotEmpty) {
      setState(() {
        items.add(item);
        prefs?.setStringList('items', items);
      });
      controller.clear();
    }
  }

  _removeItem(int index) async {
    setState(() {
      items.removeAt(index);
      prefs?.setStringList('items', items);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Dojo'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.text,
              onSubmitted: (text) => _addItem(text),
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Add Item',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _addItem(controller.text),
            child: const Text('Add'),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeItem(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
