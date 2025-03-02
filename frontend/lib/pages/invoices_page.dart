import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InvoicesPage extends StatefulWidget {
  @override
  _InvoicesPageState createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  List invoices = [];
  List customers = [];
  List items = [];
  List selectedItems = [];
  String errorMessage = '';

  TextEditingController searchIdController = TextEditingController();
  TextEditingController searchNameController = TextEditingController();
  TextEditingController customerIdController = TextEditingController();
  Map<int, TextEditingController> itemQuantityControllers = {};

  @override
  void initState() {
    super.initState();
    fetchCustomers();
    fetchItems();
  }

  Future<void> fetchCustomers() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/customers'),
      );
      if (response.statusCode == 200) {
        setState(() {
          customers = json.decode(response.body)['content'];
        });
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  Future<void> fetchItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/items'),
      );
      if (response.statusCode == 200) {
        setState(() {
          items = json.decode(response.body)['content'];
        });
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  Future<void> fetchInvoicesByCustomerId(int customerId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/invoices/customer/$customerId'),
      );
      if (response.statusCode == 200) {
        setState(() {
          invoices = json.decode(response.body);
          errorMessage = '';
        });
      } else {
        setState(
          () => errorMessage = 'No invoices found for this customer ID.',
        );
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  Future<void> fetchInvoicesByCustomerName(String name) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/invoices/customer?name=$name'),
      );
      if (response.statusCode == 200) {
        setState(() {
          invoices = json.decode(response.body);
          errorMessage = '';
        });
      } else {
        setState(
          () => errorMessage = 'No invoices found for this customer name.',
        );
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  Future<void> fetchInvoiceItems(int invoiceId) async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/invoices/$invoiceId/items'),
      );
      if (response.statusCode == 200) {
        List items = json.decode(response.body);
        showInvoiceItems(items);
      } else {
        showInvoiceItems([]);
      }
    } catch (e) {
      showInvoiceItems([]);
    }
  }

  Future<void> createInvoice() async {
    if (customerIdController.text.isEmpty || selectedItems.isEmpty) {
      setState(() => errorMessage = 'Select a customer and at least one item.');
      return;
    }

    List<Map<String, dynamic>> itemRequests =
        selectedItems.map((item) {
          return {
            'itemId': item['id'],
            'quantity':
                int.tryParse(
                  itemQuantityControllers[item['id']]?.text ?? '1',
                ) ??
                1,
          };
        }).toList();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/invoices'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'customerId': int.parse(customerIdController.text),
          'items': itemRequests,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchInvoicesByCustomerId(int.parse(customerIdController.text));
      } else {
        setState(() => errorMessage = 'Failed to create invoice.');
      }
    } catch (e) {
      setState(() => errorMessage = 'Error: $e');
    }
  }

  void showInvoiceItems(List items) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Invoice Items'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  items.isNotEmpty
                      ? items
                          .map(
                            (item) => Text(
                              '${item['itemName']} - Qty: ${item['quantity']} - \$${item['price']}',
                            ),
                          )
                          .toList()
                      : [Text('No items found')],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  void showCreateInvoiceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Create Invoice'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Customer Selection
                  DropdownButtonFormField(
                    items:
                        customers.map<DropdownMenuItem<String>>((customer) {
                          return DropdownMenuItem<String>(
                            value: customer['id'].toString(),
                            child: Text(customer['name']),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        customerIdController.text = value.toString();
                      });
                    },
                    decoration: InputDecoration(labelText: 'Select Customer'),
                  ),
                  SizedBox(height: 10),

                  // Display Selected Items + Add Button
                  Text('Selected Items:'),
                  Column(
                    children:
                        selectedItems.map((item) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item['name']),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller:
                                      itemQuantityControllers[item['id']],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Quantity',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setDialogState(() {
                                    selectedItems.remove(item);
                                    itemQuantityControllers.remove(item['id']);
                                  });
                                },
                              ),
                            ],
                          );
                        }).toList(),
                  ),

                  SizedBox(height: 10),

                  // Item Selection (Add New Item Button)
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField(
                          items:
                              items.map<DropdownMenuItem<Map<String, dynamic>>>(
                                (item) {
                                  return DropdownMenuItem<Map<String, dynamic>>(
                                    value: item,
                                    child: Text(item['name']),
                                  );
                                },
                              ).toList(),
                          onChanged: (value) {
                            if (value != null &&
                                !selectedItems.contains(value)) {
                              setDialogState(() {
                                selectedItems.add(value);
                                itemQuantityControllers[value['id']] =
                                    TextEditingController();
                              });
                            }
                          },
                          decoration: InputDecoration(labelText: 'Select Item'),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () {
                          setDialogState(() {
                            // Add an empty item selection field
                            selectedItems.add({});
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    createInvoice();
                    Navigator.pop(context);
                  },
                  child: Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invoices')),
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
                  controller: searchIdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Search by Customer ID',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  if (searchIdController.text.isNotEmpty) {
                    fetchInvoicesByCustomerId(
                      int.parse(searchIdController.text),
                    );
                  }
                },
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchNameController,
                  decoration: InputDecoration(
                    labelText: 'Search by Customer Name',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  if (searchNameController.text.isNotEmpty) {
                    fetchInvoicesByCustomerName(searchNameController.text);
                  }
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: showCreateInvoiceDialog,
            child: Text('Create Invoice'),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Invoice ID')),
                  DataColumn(label: Text('Customer Name')),
                  DataColumn(label: Text('Total Amount')),
                  DataColumn(label: Text('Items')),
                  DataColumn(label: Text('Created At')),
                ],
                rows:
                    invoices.map((invoice) {
                      return DataRow(
                        cells: [
                          DataCell(Text(invoice['id'].toString())),
                          DataCell(Text(invoice['customerName'] ?? 'N/A')),
                          DataCell(Text('\$${invoice['total'] ?? 'N/A'}')),
                          DataCell(
                            ElevatedButton(
                              onPressed: () => fetchInvoiceItems(invoice['id']),
                              child: Text('View Items'),
                            ),
                          ),
                          DataCell(Text(invoice['createdAt'] ?? 'N/A')),
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
