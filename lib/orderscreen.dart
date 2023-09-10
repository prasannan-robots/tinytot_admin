import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'homepage.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int currentPageIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .orderBy('dispatch')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No orders available.'));
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final order = snapshot.data!.docs[index];
                final orderId = order.id;
                final orderData = order.data() as Map<String, dynamic>;
                final orderStatus = orderData['dispatch'] ??
                    false; // Assuming 'status' field holds order status
                final orderaddress = orderData['address'];
                final orderphno = orderData['phonenumber'];
                final cart = orderData['cart'];
                return ListTile(
                  title: Text('Orders: $cart'),
                  subtitle: Text('dispatched: $orderStatus'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                            title: Text('Product Details'),
                            content: SingleChildScrollView(
                                // Wrap the Column with SingleChildScrollView
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                  Text("address: $orderaddress"),
                                  Text("phone number: $orderphno"),
                                  Text("cart: $cart")
                                ])));
                      },
                    );
                  },
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc(orderId)
                          .update({
                        'address': orderaddress,
                        'phonenumber': orderphno,
                        'cart': cart,
                        'dispatch': !orderStatus,
                      });
                      setState(() {});
                    },
                    child: Text(orderStatus
                        ? 'Mark Non Dispatched'
                        : 'Mark Dispatched'),
                  ),
                );
              },
            );
          },
        ),
        bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
                switch (index) {
                  case 0:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminHomePage(),
                      ),
                    );
                  case 1:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderScreen(),
                      ),
                    );
                }
              });
            },
            selectedIndex: currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(Icons.book),
                icon: Icon(Icons.home_outlined),
                label: 'Products',
              ),
              NavigationDestination(
                icon: Icon(Icons.business),
                label: 'Order',
              ),
            ]));
  }
}
