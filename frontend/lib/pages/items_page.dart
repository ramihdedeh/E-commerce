import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItemsPage extends StatefulWidget {
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  List items = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController updateNameController = TextEditingController();
  TextEditingController updatePriceController = TextEditingController();
  String errorMessage = '';

  Future<void> fetchItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/items'),
      );
      if (response.statusCode == 200) {
        setState(() {
          items = json.decode(response.body);
          errorMessage = '';
        });
      } else {
        setState(() => errorMessage = 'Failed to load items.');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  Future<void> addItem(String name, double price) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/items'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name, 'price': price}),
      );
      if (response.statusCode == 200) {
        fetchItems();
      } else {
        setState(() => errorMessage = 'Failed to add item.');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8080/api/items/$id'),
      );
      if (response.statusCode == 200) {
        fetchItems();
      } else {
        setState(() => errorMessage = 'Failed to delete item.');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  Future<void> updateItem(int id, String newName, double newPrice) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/items/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': newName, 'price': newPrice}),
      );
      if (response.statusCode == 200) {
        fetchItems();
      } else {
        setState(() => errorMessage = 'Failed to update item.');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Items')),
      body: Column(
        children: [
          if (errorMessage.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(errorMessage, style: TextStyle(color: Colors.red)),
            ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Item Name'),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Item Price'),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      priceController.text.isNotEmpty) {
                    addItem(
                      nameController.text,
                      double.parse(priceController.text),
                    );
                    nameController.clear();
                    priceController.clear();
                  }
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: fetchItems,
            child: Text('Display All Items'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]['name']),
                  subtitle: Text('Price: ${items[index]['price']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          updateNameController.text = items[index]['name'];
                          updatePriceController.text =
                              items[index]['price'].toString();
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text('Update Item'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: updateNameController,
                                        decoration: InputDecoration(
                                          labelText: 'New Name',
                                        ),
                                      ),
                                      TextField(
                                        controller: updatePriceController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          labelText: 'New Price',
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        updateItem(
                                          items[index]['id'],
                                          updateNameController.text,
                                          double.parse(
                                            updatePriceController.text,
                                          ),
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text('Update'),
                                    ),
                                  ],
                                ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => deleteItem(items[index]['id']),
                      ),
                    ],
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
