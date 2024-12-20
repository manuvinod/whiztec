import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PickupDetailsPage extends StatefulWidget {
  final String userName;
  final String itemDetails;
  final String location;
  final String pickupDate;
  final String pickupDocId;

  PickupDetailsPage({required this.userName, required this.itemDetails, required this.location, required this.pickupDate, required this.pickupDocId,});
  @override
  _PickupDetailsPageState createState() => _PickupDetailsPageState();
}
class _PickupDetailsPageState extends State<PickupDetailsPage> {
  bool isChecked1 = false;
  bool isChecked2 = false;
  bool isChecked3 = false;
  bool isChecked4 = false;
  bool isChecked5 = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> savePickupStatus() async {
    try {
      Map<String, String> statusMap = {};
      if (isChecked1) statusMap['itemPicked'] = "Item Picked";
      if (isChecked3) statusMap['doorClosed'] = "Door Closed";
      if (isChecked4) statusMap['wrongAddress'] = "Wrong Address";
      if (isChecked5) statusMap['itemNotReady'] = "Item Not Ready";

      await _firestore.collection('pickupStatus').add({
        'userName': widget.userName,
        'itemDetails': widget.itemDetails,
        'location': widget.location,
        'pickupDate': widget.pickupDate,
        ...statusMap,
        'timestamp': FieldValue.serverTimestamp(),
      });
      await _firestore.collection('pick').doc(widget.pickupDocId).delete();
      Navigator.pop(context);

    } catch (e) {
      print("Error saving data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Padding(
          padding: const EdgeInsets.only(right: 70),
          child: Center(child: Text('Pickup Status', style: TextStyle(color: Colors.white))),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Name:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.indigo[900])),
            Text(widget.userName, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Item Details:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.indigo[900])),
            Text(widget.itemDetails, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Location:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.indigo[900])),
            Text(widget.location, style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Pickup Date:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.indigo[900])),
            Text(widget.pickupDate, style: TextStyle(fontSize: 16)),
            SizedBox(height: 30),
            Text('Status:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.indigo[900])),
            Row(
              children: [
                Checkbox(
                  value: isChecked1,
                  onChanged: (value) {
                    setState(() {
                      isChecked1 = value!;
                      isChecked2 = false;
                      isChecked3 = false;
                      isChecked4 = false;
                      isChecked5 = false;
                    });
                  },
                ),
                Text("Item Picked", style: TextStyle(fontSize: 16)),
              ],
            ),

            Row(
              children: [
                Checkbox(
                  value: isChecked3,
                  onChanged: (value) {
                    setState(() {
                      isChecked3 = value!;
                      isChecked1 = false;
                      isChecked2 = false;
                      isChecked4 = false;
                      isChecked5 = false;
                    });
                  },
                ),
                Text("Door is Closed", style: TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isChecked4,
                  onChanged: (value) {
                    setState(() {
                      isChecked4 = value!;
                      isChecked1 = false;
                      isChecked2 = false;
                      isChecked3 = false;
                      isChecked5 = false;
                    });
                  },
                ),
                Text("Wrong Address", style: TextStyle(fontSize: 16)),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: isChecked5,
                  onChanged: (value) {
                    setState(() {
                      isChecked5 = value!;
                      isChecked1 = false;
                      isChecked2 = false;
                      isChecked3 = false;
                      isChecked4 = false;
                    });
                  },
                ),
                Text("Item Not Ready", style: TextStyle(fontSize: 16)),
              ],
            ),

            SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: ElevatedButton(
                onPressed: savePickupStatus,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo[900],minimumSize: Size(300, 60)),
                child: Text("Update Status", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
