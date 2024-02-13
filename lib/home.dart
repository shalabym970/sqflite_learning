import 'package:flutter/material.dart';
import 'package:sqflite_learning/sqldb.dart';

import 'edit_notes.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SqlDb sqlDb = SqlDb();
  bool isLoading = true;
  List notes = [];

  readData() async {
    List<Map> response = await sqlDb.read(table: "notes");
    notes.addAll(response);

    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed('add_notes');
          },
          child: const Icon(Icons.add),
        ),
        body: isLoading == true
            ? const Center(
                child: Text('loading...'),
              )
            : ListView(
                children: [
                  ListView.builder(
                      itemCount: notes.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return Card(
                          child: ListTile(
                            title: Text("${notes[i]['title']}"),
                            subtitle: Text("${notes[i]['note']}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => EditNote(
                                                  title: notes[i]['title'],
                                                  note: notes[i]['note'],
                                                  id: notes[i]['id'],
                                                )));
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    int response = await sqlDb.delete(
                                        where: 'id = ${notes[i]['id']}',
                                        table: 'notes ');
                                    // int response = await sqlDb.deleteData(
                                    //     sql:
                                    //         'DELETE FROM notes id = ${notes[i]['id']}');
                                    if (response > 0) {
                                      notes.removeWhere((element) =>
                                          element['id'] == notes[i]['id']);
                                      setState(() {});
                                    }
                                    print('======== $response =======');
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                ],
              ));
  }
}
