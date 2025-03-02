import 'package:flutter/material.dart';
import 'customers_page.dart';
import 'items_page.dart';
import 'invoices_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Apliman',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Removes shadow under the AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20), // Space above buttons
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomersPage()),
                  ),
              child: Text('Manage Customers'),
            ),
            SizedBox(height: 15), // Space between buttons
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ItemsPage()),
                  ),
              child: Text('Manage Items'),
            ),
            SizedBox(height: 15), // Space between buttons
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InvoicesPage()),
                  ),
              child: Text('Manage Invoices'),
            ),
          ],
        ),
      ),
    );
  }
}
