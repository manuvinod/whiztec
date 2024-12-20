import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Controller/Auth_Controller.dart';

class PickupRequestPage extends StatefulWidget {
  @override
  _PickupRequestPageState createState() => _PickupRequestPageState();
}

class _PickupRequestPageState extends State<PickupRequestPage> {
  final _formKey = GlobalKey<FormState>();
  String? _itemDetails;
  String? _location;
  DateTime? _pickupDate;

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('requests')
            .add({
          'itemDetails': _itemDetails,
          'location': _location,
          'pickupDate': _pickupDate?.toIso8601String(),
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pickup request submitted successfully!')),
        );
        setState(() {
          _itemDetails = null;
          _location = null;
          _pickupDate = null;
        });

        _formKey.currentState!.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.indigo[900],
        title: Center(child: Text('Whiztech',style: TextStyle(color:Colors.white),)),
        actions: <Widget>[
          IconButton(onPressed: (){
            AuthController().logout(context);
          }, icon: Icon(Icons.power_settings_new_outlined,color: Colors.white,)),

        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 200,),
              TextFormField(
                decoration: InputDecoration(labelText: 'Item Details'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item details';
                  }
                  return null;
                },
                onSaved: (value) {
                  _itemDetails = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _location = value;
                },
              ),
              ListTile(
                title: Text(_pickupDate == null
                    ? 'Select Pickup Date'
                    : 'Pickup Date: ${_pickupDate}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null && pickedDate != _pickupDate) {
                    setState(() {
                      _pickupDate = pickedDate;
                    });
                  }
                },
              ),
              Divider(),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo[900],shape: BeveledRectangleBorder(),minimumSize: Size(300, 60)),
                child: Text('Submit Request',style: TextStyle(color: Colors.white,fontSize: 20),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
