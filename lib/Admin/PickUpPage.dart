import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PickupStatusDetailsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> deleteDocument(String docId) async {
      await _firestore.collection('pickupStatus').doc(docId).delete();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('pickupStatus').orderBy('timestamp', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No data available',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            );
          }
          final documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              final data = documents[index].data() as Map<String, dynamic>;
              final userName = data['userName'] ?? 'N/A';
              final itemDetails = data['itemDetails'] ?? 'N/A';
              final location = data['location'] ?? 'N/A';
              final pickupDate = data['pickupDate'] ?? 'N/A';
              final itemPicked = data['itemPicked'] ?? '';
              final doorClosed = data['doorClosed'] ?? '';
              final wrongAddress = data['wrongAddress'] ?? '';
              final itemNotReady = data['itemNotReady'] ?? '';
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  trailing: ElevatedButton(
                    onPressed: () => deleteDocument(doc.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo[900],
                      minimumSize: Size(60, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Done",style: TextStyle(color:Colors.white),),
                  ),
                  title: Text(
                    userName,
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.indigo[900]),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Item: $itemDetails"),
                      Text("Location: $location"),
                      Text("Pickup Date: $pickupDate"),
                      SizedBox(height: 5),
                      Text("Status: ${itemPicked.isNotEmpty ? itemPicked : doorClosed.isNotEmpty ? doorClosed : wrongAddress.isNotEmpty ? wrongAddress : itemNotReady.isNotEmpty ? itemNotReady : 'No Status'}",
                        style: TextStyle(color: Colors.indigo[900], fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
