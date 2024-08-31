import 'dart:io';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:students_note_app/pages/notes/widgets/image_input.dart';
import 'package:students_note_app/services/models/notes_model.dart';
import 'package:students_note_app/services/providers/folder_provider.dart';
import 'package:students_note_app/services/providers/notes_provider.dart';

class NotesAdd extends ConsumerStatefulWidget {
  const NotesAdd({super.key, required this.note});

  final NotesModel? note;

  @override
  ConsumerState<NotesAdd> createState() {
    return _NotesAddState();
  }
}

class _NotesAddState extends ConsumerState<NotesAdd> {
  // final _notesControler = TextEditingController();
  // // final QuillController _notesController = QuillController.basic();
  // final _titleController = TextEditingController();

  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  File? selectedImage;
  String? selectedFolderId;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _notesController.text = widget.note!.note;
      selectedImage = widget.note!.image;
    }
  }

  void _saveNotes() {
    final enteredTitle = _titleController.text;
    final enteredNote = _notesController.text;

    if (enteredTitle.isEmpty) return;

    if (widget.note != null) {
      // update the existing note
      final updatedNote = NotesModel(
        id: widget.note!.id,
        image: selectedImage!,
        title: enteredTitle,
        note: enteredNote,
      );

      ref.read(userNoteprovider.notifier).updateNote(updatedNote);
    } else {
      // add new note

      ref.read(userNoteprovider.notifier).addNote(
            selectedImage!,
            enteredTitle,
            enteredNote,
          );
    }

    Navigator.of(context).pop();
  }

  void _createNewFolder(BuildContext context) {
    final folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Create New Folder'),
        content: TextField(
          controller: folderNameController,
          decoration: const InputDecoration(hintText: 'Enter folder name'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final folderName = folderNameController.text;
              if (folderName.isNotEmpty) {
                ref.read(folderProvider.notifier).addFolder(folderName);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _notesController.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final folders = ref.watch(folderProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(widget.note == null ? 'Add your Note' : 'Update Your Note'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert),
            )
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // folders drop down
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.folder_outlined,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        'Folder',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                  // save the notes..
                  IconButton(
                      onPressed: _saveNotes, icon: const Icon(Icons.save)),
                ],
              ),

              // title textfield

              TextFormField(
                maxLines: 1,
                controller: _titleController,
                style: TextStyle(
                    color: theme.colorScheme.inversePrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: InputBorder.none,
                ),
              ),

              SizedBox(
                width: screenSize.width,
                height: 200,
                child: ImageInput(
                  onPickImage: (image) {
                    selectedImage = image;
                  },
                  initialImage: widget.note?.image,
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              Container(
                width: double.infinity,
                height: screenSize.height,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20)),
                child: TextFormField(
                  controller: _notesController,
                  style: TextStyle(
                      color: theme.colorScheme.inverseSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                  decoration: InputDecoration(
                    labelText: 'Type Notes',
                    hintStyle:
                        TextStyle(color: theme.colorScheme.inversePrimary),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  minLines: 1,
                  keyboardType: TextInputType.multiline,
                ),
              ),

              // const Text(
              //   'Type your Notes: ',
              //   style:
              //       TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(
              //   height: 8,
              // ),

              // Wrap(
              //   children: [
              //     SingleChildScrollView(
              //         child: Column(
              //       children: [
              //         Container(
              //           width: double.infinity,
              //           height: screenSize.height / 3,
              //           padding: const EdgeInsets.all(16),
              //           decoration: BoxDecoration(
              //             color: const Color.fromARGB(81, 187, 187, 187),
              //             borderRadius: BorderRadius.circular(20),
              //           ),
              //           child: QuillEditor.basic(
              //             controller: _notesController,
              //             configurations: const QuillEditorConfigurations(
              //               checkBoxReadOnly: false,
              //               autoFocus: true,
              //             ),
              //           ),
              //         ),
              //         SingleChildScrollView(
              //           scrollDirection: Axis.horizontal,
              //           child: Container(
              //             padding: const EdgeInsets.all(12),
              //             margin: const EdgeInsets.only(top: 20),
              //             decoration: BoxDecoration(
              //                 color: Colors.white54,
              //                 borderRadius: BorderRadius.circular(20)),
              //             child: QuillSimpleToolbar(
              //               controller: _notesController,
              //               configurations:
              //                   const QuillSimpleToolbarConfigurations(
              //                       axis: Axis.horizontal, color: Colors.white),
              //             ),
              //           ),
              //         ),
              //       ],
              //     )),
              //   ],
              // ),
              const SizedBox(
                height: 8,
              ),

              // notes type textfield
              // Container(
              //   width: screenSize.width,
              //   height: screenSize.height,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(20),
              //   ),
              //   child: TextFormField(
              //     controller: _notesController,
              //     onSaved: (newValue) {},
              //     keyboardType: TextInputType.text,
              //     validator: (value) {},
              //     maxLines: 100,
              //     minLines: 1,
              //     decoration: const InputDecoration(
              //       labelText: 'Type your Notes',
              //       contentPadding: EdgeInsets.all(20),
              //       border: InputBorder.none,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
