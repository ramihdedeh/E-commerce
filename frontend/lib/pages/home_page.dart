import 'package:flutter/material.dart';
import 'customers_page.dart';
import 'items_page.dart';
import 'invoices_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('E-Commerce Admin Panel')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CustomersPage()),
                  ),
              child: Text('Manage Customers'),
            ),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ItemsPage()),
                  ),
              child: Text('Manage Items'),
            ),
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
