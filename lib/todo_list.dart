import 'package:firebase_database/firebase_database.dart';
import 'package:firebasetodo/Edit.dart';
import 'package:flutter/material.dart';
import 'mydata.dart';
import 'todo_datail.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<mydata> allData = [];
  @override
  void initState() {
    _loadContacts();
    super.initState();
  }

  void _loadContacts() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('contact').once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      allData.clear();
      for (var key in keys) {
        mydata d = new mydata(data[key]['name'], data[key]['number'],
            data[key]['email'], data[key]['address'], data[key]['imageurl']);
        allData.add(d);
      }
    });
    print(allData.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
      ),
      body: allData.length != 0
          ? ListView.builder(
              itemCount: allData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Edit(allData, index)));
                  },
                  child: Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(allData[index].imageurl),
                      ),
                      title: Text(allData[index].name),
                      subtitle: Text(allData[index].number),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : CircularProgressIndicator(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TodoDetail()));
        },
        child: Icon(
          Icons.note_add,
          color: Colors.white,
        ),
      ),
    );
  }
}
