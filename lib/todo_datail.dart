import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TodoDetail extends StatefulWidget{
  @override
  _TodoDetailState createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController address = TextEditingController();
  var priority = 'Priority';
  File _image;
  Future getimage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add todo'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.delete,
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            DropdownButton<String>(
              // focusColor: Colors.white,
              value: priority,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.white),
              onChanged: (String newValue) {
                setState(() {
                  priority = newValue;
                });
              },
              items: ['Priority', 'Low', 'High']
                  .map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                );
              }).toList(),
            ),
            GestureDetector(
              onTap: () {
                getimage();
              },
              child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _image != null
                      ? FileImage(_image)
                      : NetworkImage(
                          "https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500")),
            ),
            TextField(
              controller: name,
              decoration:
                  InputDecoration(icon: Icon(Icons.title), hintText: 'Name'),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            TextField(
              controller: number,
              decoration: InputDecoration(
                  icon: Icon(Icons.description), hintText: 'Number'),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            TextField(
              controller: email,
              decoration: InputDecoration(
                  icon: Icon(Icons.description), hintText: 'Email'),
            ),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            TextField(
              controller: address,
              decoration: InputDecoration(
                  icon: Icon(Icons.description), hintText: 'Address'),
            ),
            Padding(
              padding: EdgeInsets.all(20),
            ),
            MaterialButton(
              onPressed: () {sendToServer();},
              color: Colors.green,
              child: Text('SAVE', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
  sendToServer()async{
    
    final StorageReference firebaseStorageRef=FirebaseStorage.instance.ref().child('image');
    final StorageUploadTask task=firebaseStorageRef.child(name.text).putFile(_image);

    StorageTaskSnapshot taskSnapshot=await task.onComplete;
    String downloadurl=await taskSnapshot.ref.getDownloadURL();
    print(downloadurl);


    DatabaseReference ref =FirebaseDatabase.instance.reference();
    var data={
      "name":name.text,
      "number":number.text,
      "email":email.text,
      "address":address.text,
      "imageurl":downloadurl
    };

    ref.child('contact').child(name.text).set(data).then((v){
      
     });

  }
}
