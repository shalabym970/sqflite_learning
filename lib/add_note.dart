import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_learning/home.dart';
import 'package:sqflite_learning/sqldb.dart';

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  SqlDb sqlDb = SqlDb();
  GlobalKey formState = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add note'),
      ),
      body: ListView(children: [
        Form(
          key: formState,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: 'title'),
                ),
                TextFormField(
                  controller: noteController,
                  decoration: const InputDecoration(hintText: 'note'),
                ),
                MaterialButton(
                  onPressed: () async {
                    int response = await sqlDb.insert(table: "notes", values: {
                      "note": noteController.text,
                      "title": titleController.text,
                    });
                    // int response = await sqlDb.insertData(sql: '''
                    //  INSERT INTO notes ('title' ,'note') VALUES    ("${titleController.text}" ,"${noteController.text}")
                    // ''');
                    if (response > 0) {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const Home(
                                    title: 'Notes',
                                  )),
                          (route) => false);
                    }
                    print('======== response : $response ========== ');
                  },
                  child: const Text('add'),
                  textColor: Colors.blue,
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
