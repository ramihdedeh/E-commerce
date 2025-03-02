import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomersPage extends StatefulWidget {
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  List customers = [];
  String errorMessage = '';
  TextEditingController updateNameController = TextEditingController();
  TextEditingController addNameController = TextEditingController();

  Future<void> fetchCustomers() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/customers'),
      );
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey("content")) {
          setState(() {
            customers = jsonResponse["content"];
            errorMessage = '';
          });
        } else {
          setState(() {
            customers = [];
            errorMessage = 'Invalid response format';
          });
        }
      } else {
        setState(() => errorMessage = 'Failed to load customers.');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  Future<void> addCustomer(String name) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/customers'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': name}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchCustomers();
      } else {
        setState(() => errorMessage = 'Failed to add customer.');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  Future<void> deleteCustomer(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8080/api/customers/$id'),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          customers.removeWhere((customer) => customer['id'] == id);
        });
      } else {
        setState(() => errorMessage = 'Failed to delete customer.');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  Future<void> updateCustomer(int id, String newName) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/customers/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id, 'name': newName}),
      );
      if (response.statusCode == 200) {
        setState(() {
          customers =
              customers.map((customer) {
                if (customer['id'] == id) {
                  return {'id': id, 'name': newName};
                }
                return customer;
              }).toList();
        });
      } else {
        setState(() => errorMessage = 'Failed to update customer.');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customers')),
      body: Column(
        children: [
          if (errorMessage.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(errorMessage, style: TextStyle(color: Colors.red)),
            ),
          ElevatedButton(
            onPressed: fetchCustomers,
            child: Text('Display All Customers'),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('Add Customer'),
                      content: TextField(
                        controller: addNameController,
                        decoration: InputDecoration(labelText: 'Customer Name'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            addCustomer(addNameController.text);
                            addNameController.clear();
                            Navigator.pop(context);
                          },
                          child: Text('Add'),
                        ),
                      ],
                    ),
              );
            },
            child: Text('Add Customer'),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Actions')),
                ],
                rows:
                    customers.map((customer) {
                      return DataRow(
                        cells: [
                          DataCell(Text(customer['id'].toString())),
                          DataCell(Text(customer['name'])),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    updateNameController.text =
                                        customer['name'];
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => AlertDialog(
                                            title: Text('Update Customer'),
                                            content: TextField(
                                              controller: updateNameController,
                                              decoration: InputDecoration(
                                                labelText: 'New Name',
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  updateCustomer(
                                                    customer['id'],
                                                    updateNameController.text,
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
                                  onPressed:
                                      () => deleteCustomer(customer['id']),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
