import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InvoicesPage extends StatefulWidget {
  @override
  _InvoicesPageState createState() => _InvoicesPageState();
}

class _InvoicesPageState extends State<InvoicesPage> {
  List invoices = [];

  Future<void> fetchInvoicesByCustomer(int customerId) async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/invoices/customer/$customerId'),
    );
    if (response.statusCode == 200) {
      setState(() {
        invoices = json.decode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Invoices')),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Enter Customer ID'),
                onSubmitted:
                    (value) => fetchInvoicesByCustomer(int.parse(value)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: invoices.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Invoice ID: ${invoices[index]['id']}'),
                    subtitle: Text('Total: \$${invoices[index]['total']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
