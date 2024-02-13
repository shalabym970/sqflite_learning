import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_learning/home.dart';
import 'package:sqflite_learning/sqldb.dart';

class EditNote extends StatefulWidget {
  final note;
  final title;
  final id;

  const EditNote(
      {Key? key, required this.note, required this.title, required this.id})
      : super(key: key);

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  SqlDb sqlDb = SqlDb();
  GlobalKey formState = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    noteController.text = widget.note;
    titleController.text = widget.title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit note'),
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
                    int response = await sqlDb.update(
                        table: "notes",
                        values: {
                          "note": noteController.text,
                          "title": titleController.text
                        },
                        where: "id = ${widget.id}");
                    // int response = await sqlDb.updateData(sql: '''
                    //  UPDATE notes SET
                    //  note = "${noteController.text}",
                    //  title = "${titleController.text}"
                    //  WHERE id = ${widget.id}
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
                  textColor: Colors.blue,
                  child: const Text('edit'),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
