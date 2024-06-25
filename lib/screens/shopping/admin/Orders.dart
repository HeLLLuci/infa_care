import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  late Stream<QuerySnapshot> _ordersStream;

  @override
  void initState() {
    super.initState();
    _ordersStream = FirebaseFirestore.instance
        .collection('shops')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Orders')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Text('Order ID'),
                ),
                DataColumn(
                  label: Text('Customer Name'),
                ),
                DataColumn(
                  label: Text('Order Date'),
                ),
                DataColumn(
                  label: Text('Action'),
                ),
              ],
              rows: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                document.data() as Map<String, dynamic>;
                return DataRow(
                  cells: <DataCell>[
                    DataCell(
                      Text(document.id),
                    ),
                    DataCell(
                      Text(data['customer_name'] ?? ''),
                    ),
                    DataCell(
                      Text(data['order_date'] != null
                          ? (data['order_date'] as Timestamp)
                          .toDate()
                          .toString()
                          : ''),
                    ),
                    DataCell(
                      ElevatedButton(
                        onPressed: () {
                          // Add your logic to generate and download PDF here
                        },
                        child: Text('Download PDF'),
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          }
          return Text('No orders found.');
        },
      ),
    );
  }
}
