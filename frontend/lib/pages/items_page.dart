import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ItemsPage extends StatefulWidget {
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  List items = [];
  String errorMessage = '';
  int page = 0;
  final int pageSize = 10;
  int totalPages = 1;
  TextEditingController updateNameController = TextEditingController();
  TextEditingController updateDescriptionController = TextEditingController();
  TextEditingController updatePriceController = TextEditingController();
  TextEditingController updateStockController = TextEditingController();
  TextEditingController addNameController = TextEditingController();
  TextEditingController addDescriptionController = TextEditingController();
  TextEditingController addPriceController = TextEditingController();
  TextEditingController addStockController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  Future<void> fetchItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/items?page=$page&size=$pageSize'),
      );
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey("content")) {
          setState(() {
            items =
                jsonResponse["content"]
                    .where((item) => item['deleted'] != 1)
                    .toList();
            totalPages = jsonResponse["totalPages"] ?? 1;
            errorMessage = '';
          });
        } else {
          setState(() {
            items = [];
            errorMessage = 'Invalid response format';
          });
        }
      } else {
        setState(() => errorMessage = 'Failed to load items.');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  Future<void> fetchItemByName(String name) async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://localhost:8080/api/items/search?name=$name&page=0&size=10',
        ),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey("content")) {
          setState(() {
            items =
                jsonResponse["content"]; // Correctly setting items as a list
            errorMessage = items.isEmpty ? 'No items found.' : '';
          });
        } else {
          setState(() => errorMessage = 'Invalid response format.');
        }
      } else {
        setState(() => errorMessage = 'Failed to fetch item.');
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
      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          items.removeWhere((item) => item['id'] == id);
        });
      } else {
        setState(() => errorMessage = 'Failed to delete item.');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  Future<void> updateItem(
    int id,
    String newName,
    String newDescription,
    double newPrice,
    int newStock,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/items/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': id,
          'name': newName,
          'description': newDescription,
          'price': newPrice,
          'stock': newStock,
        }),
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

  Future<void> addItem(
    String name,
    String description,
    double price,
    int stock,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/items'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': name,
          'description': description,
          'price': price,
          'stock': stock,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchItems();
      } else {
        setState(() => errorMessage = 'Failed to add item.');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  void nextPage() {
    if (page < totalPages - 1) {
      setState(() {
        page++;
      });
      fetchItems();
    }
  }

  void previousPage() {
    if (page > 0) {
      setState(() {
        page--;
      });
      fetchItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Items')),
      body: SingleChildScrollView(
        // 🔹 Ensures page is scrollable
        child: Column(
          children: [
            if (errorMessage.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(errorMessage, style: TextStyle(color: Colors.red)),
              ),

            // 🔹 Search Bar for Searching Items
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(labelText: 'Search by Name'),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      if (searchController.text.isNotEmpty) {
                        fetchItemByName(searchController.text);
                      }
                    },
                  ),
                ],
              ),
            ),

            // 🔹 Buttons (Display All Items & Add Item)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: fetchItems, // Reset to display all items
                    child: Text('Display All Items'),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: Text('Add New Item'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: addNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Item Name',
                                    ),
                                  ),
                                  TextField(
                                    controller: addDescriptionController,
                                    decoration: InputDecoration(
                                      labelText: 'Description',
                                    ),
                                  ),
                                  TextField(
                                    controller: addPriceController,
                                    decoration: InputDecoration(
                                      labelText: 'Price',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                  TextField(
                                    controller: addStockController,
                                    decoration: InputDecoration(
                                      labelText: 'Stock',
                                    ),
                                    keyboardType: TextInputType.number,
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    addItem(
                                      addNameController.text,
                                      addDescriptionController.text,
                                      double.parse(addPriceController.text),
                                      int.parse(addStockController.text),
                                    );
                                    addNameController.clear();
                                    addDescriptionController.clear();
                                    addPriceController.clear();
                                    addStockController.clear();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Add'),
                                ),
                              ],
                            ),
                      );
                    },
                    child: Text('Add Item'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10), // Space before table
            // 🔹 Scrollable Data Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Description')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Stock')),
                  DataColumn(label: Text('Actions')),
                ],
                rows:
                    items.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item['id'].toString())),
                          DataCell(Text(item['name'])),
                          DataCell(Text(item['description'])),
                          DataCell(Text('\$${item['price']}')),
                          DataCell(Text(item['stock'].toString())),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    updateNameController.text = item['name'];
                                    updateDescriptionController.text =
                                        item['description'];
                                    updatePriceController.text =
                                        item['price'].toString();
                                    updateStockController.text =
                                        item['stock'].toString();
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text('Update Item'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextField(
                                                  controller:
                                                      updateNameController,
                                                  decoration: InputDecoration(
                                                    labelText: 'New Name',
                                                  ),
                                                ),
                                                TextField(
                                                  controller:
                                                      updateDescriptionController,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        'New Description',
                                                  ),
                                                ),
                                                TextField(
                                                  controller:
                                                      updatePriceController,
                                                  decoration: InputDecoration(
                                                    labelText: 'New Price',
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                                TextField(
                                                  controller:
                                                      updateStockController,
                                                  decoration: InputDecoration(
                                                    labelText: 'New Stock',
                                                  ),
                                                  keyboardType:
                                                      TextInputType.number,
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  updateItem(
                                                    item['id'],
                                                    updateNameController.text,
                                                    updateDescriptionController
                                                        .text,
                                                    double.parse(
                                                      updatePriceController
                                                          .text,
                                                    ),
                                                    int.parse(
                                                      updateStockController
                                                          .text,
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
                                  onPressed: () => deleteItem(item['id']),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),

            SizedBox(height: 20), // Space before pagination buttons
            // 🔹 Pagination Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: page > 0 ? previousPage : null,
                    child: Text('Previous Page'),
                  ),
                  ElevatedButton(
                    onPressed: page < totalPages - 1 ? nextPage : null,
                    child: Text('Next Page'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
