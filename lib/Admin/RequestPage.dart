import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whiztec/Admin/RequestDetails.dart';

class UserReuest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where("Email", isNotEqualTo: "whiztechadmin@1123.com")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var userDoc = snapshot.data!.docs[index];
              var userId = userDoc.id;
              var userName = userDoc["Username"] ?? "Unknown User";

              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('Users')
                    .doc(userId)
                    .collection('requests')
                    .get(),
                builder: (context, requestSnapshot) {
                  if (requestSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text(userName),
                      subtitle: Text('Loading requests...'),
                    );
                  }

                  int requestCount = requestSnapshot.data?.docs.length ?? 0;

                  return ListTile(
                    title: Text(userName,style: TextStyle(fontSize: 18,fontWeight:FontWeight.bold),),
                    trailing: CircleAvatar(
                      backgroundColor: Colors.red,
                        radius: 12,
                        child: Text('$requestCount',style: TextStyle(color: Colors.white),)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RequestDetails(
                            userId: userId,
                            userName: userName,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
