import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_structure/components/custom_text_fields.dart';
import 'package:project_structure/databases/local/models/notes.dart';
import 'package:project_structure/databases/local/notesDatabase.dart';
import 'package:project_structure/theme/Palette.dart';

class NoteForm extends StatefulWidget {
  final Note? note;
  const NoteForm({
    super.key,
    this.note,
  });

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  @override
  void initState() {
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      numberController.text = widget.note!.number.toString();
      descriptionController.text = widget.note!.description;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      elevation: 4,
      backgroundColor: Palette.blueColor,
      showCloseIcon: true,
      content: Text(
        message,
        style: const TextStyle(color: Palette.whiteColor, fontSize: 14),
      ),
      action: SnackBarAction(
        label: '',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> updateNote() async {
    if (titleController.text.isEmpty) {
      showSnackBar("Le titre ne peut être vide");
      return;
    }

    if (numberController.text.isEmpty) {
      showSnackBar("Le niveau ne peut être vide");
      return;
    }

    if (descriptionController.text.isEmpty) {
      showSnackBar("La description ne peut être vide");
      return;
    }

    Note note = Note(
        id: widget.note!.id,
        isImportant: widget.note!.isImportant,
        number: numberController.text.isNotEmpty
            ? int.parse(numberController.text)
            : 0,
        title: titleController.text,
        description: descriptionController.text,
        createdTime: widget.note!.createdTime);
    await NotesDatabase.instance.update(note);
    Navigator.pop(context);
  }

  Future<void> addNote() async {
    if (titleController.text.isEmpty) {
      showSnackBar("Le titre ne peut être vide");
      return;
    }

    if (numberController.text.isEmpty) {
      showSnackBar("Le niveau ne peut être vide");
      return;
    }

    if (descriptionController.text.isEmpty) {
      showSnackBar("La description ne peut être vide");
      return;
    }

    Note note = Note(
        isImportant: true,
        number: numberController.text.isNotEmpty
            ? int.parse(numberController.text)
            : 0,
        title: titleController.text,
        description: descriptionController.text,
        createdTime: DateTime.now());
    note = await NotesDatabase.instance.create(note);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Palette.whiteColor,
      appBar: AppBar(
        backgroundColor: Palette.whiteColor,
        elevation: 4,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(CupertinoIcons.arrow_left,
                color: Palette.blueColor, size: 24)),
        title: const Text(
          "Ajouter une note",
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                  controller: titleController,
                  hintText: "Titre",
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: numberController,
                  hintText: "Niveau de difficulté",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: descriptionController,
                  hintText: "Description",
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () async {
                      if (widget.note == null) {
                        await addNote();
                      } else {
                        await updateNote();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      decoration: BoxDecoration(
                          color: Palette.blueColor,
                          borderRadius: BorderRadius.circular(40)),
                      child: Text(
                        widget.note != null ? "Mettre à jour" : "Ajouter",
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                )
              ]),
        ),
      ),
    ));
  }
}
