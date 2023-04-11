import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_structure/databases/local/models/notes.dart';
import 'package:project_structure/databases/local/notesDatabase.dart';
import 'package:project_structure/features/auth/views/note_form.dart';
import 'package:project_structure/theme/Palette.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // C'est cette classe qui sert de controller
  List<Note> notes = [];
  Note? note;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Appel de la méthode qui va lister toutes les notes de la base de données
    refreshNote();
  }

  @override
  void dispose() {
    NotesDatabase.instance.close();
    super.dispose();
  }

  Future<void> delete(Note note) async {
    setState(() {
      isLoading = true;
    });
    await NotesDatabase.instance.delete(note.id!);
    notes.remove(note);
    setState(() {
      isLoading = false;
    });
  }

  Future refreshNote() async {
    setState(() {
      isLoading = true;
    });
    notes = await NotesDatabase.instance.readAllNotes();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        title: Row(
          children: [
            const Icon(Icons.edit, color: Palette.blueColor, size: 26),
            const SizedBox(
              width: 8,
            ),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteForm()),
          );
        },
        tooltip: 'Ajouter une note',
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          notes.isEmpty
              ? Container(
                  height: 350,
                  decoration: const BoxDecoration(),
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Aucune note présente",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                )
              : Container(),
          ...List.generate(
              notes.length,
              (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Stack(
                      children: [
                        InkWell(
                          onLongPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NoteForm(
                                        note: notes[index],
                                      )),
                            );
                          },
                          onDoubleTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NoteForm(
                                        note: notes[index],
                                      )),
                            );
                          },
                          child: Card(
                            color: notes[index].number >= 3
                                ? Colors.red.withOpacity(0.5)
                                : (notes[index].number == 2
                                    ? Colors.orange.withOpacity(0.4)
                                    : (Colors.green.withOpacity(0.4))),
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                        DateFormat.yMMMd()
                                            .format(notes[index].createdTime),
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Colors.black.withOpacity(0.6))),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              color: notes[index].number >= 3
                                                  ? Colors.red
                                                  : (notes[index].number == 2
                                                      ? Colors.orange
                                                      : (Colors.green)),
                                              shape: BoxShape.circle),
                                          child: Center(
                                            child: Text(
                                                notes[index].number.toString(),
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.white)),
                                          )),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(notes[index].title.toString(),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black87
                                                  .withOpacity(0.6))),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(notes[index].description.toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Colors.black.withOpacity(0.8))),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            top: 36,
                            right: 10,
                            child: InkWell(
                              onTap: () async {
                                await delete(notes[index]);
                              },
                              child: Icon(Icons.delete,
                                  color: Colors.grey[200], size: 26),
                            ))
                      ],
                    ),
                  )),
        ]),
      ),
    ));
  }
}
