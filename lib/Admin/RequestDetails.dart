import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestDetails extends StatelessWidget {
  final String userId;
  final String userName;
  RequestDetails({required this.userId, required this.userName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text('$userName',style: TextStyle(color: Colors.white),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('requests')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No requests found for this user.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var request = snapshot.data!.docs[index];
              var itemDetails = request['itemDetails'] ?? 'N/A';
              var location = request['location'] ?? 'N/A';
              var pickupDate = request['pickupDate'] ?? 'N/A';
              var requestId=request.id;
              return Column(
                children: [
                  ListTile(
                    title: Text('Item: $itemDetails',style: TextStyle(color:Colors.indigo[900],fontWeight: FontWeight.bold),),
                    subtitle: Text('Location: $location\nDate: $pickupDate'),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance.collection('pick').add({
                          'userId': userId,
                          'userName': userName,
                          'itemDetails': itemDetails,
                          'location': location,
                          'pickupDate': pickupDate,
                        });
                        await FirebaseFirestore.instance.collection("Users").doc(userId).collection("requests").doc(requestId).delete();

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Request details saved for pickup')));
                      },style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo[900]),
                      child: Text('Pick',style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  Divider()
                ],
              );
            },
          );
        },
      ),
    );
  }
}
