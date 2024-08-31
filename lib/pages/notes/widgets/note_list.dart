import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:students_note_app/pages/notes/widgets/notes_add.dart';
import 'package:students_note_app/pages/notes/widgets/notes_item.dart';
import 'package:students_note_app/services/providers/notes_provider.dart';

class NoteList extends ConsumerStatefulWidget {
  const NoteList({super.key});

  @override
  ConsumerState<NoteList> createState() {
    return _NoteListState();
  }
}

class _NoteListState extends ConsumerState<NoteList> {
  @override
  Widget build(BuildContext context) {
    final userNotes = ref.watch(userNoteprovider);
    return userNotes.isEmpty
        ? const Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Text(
                'No Notes added yet',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )
        : MasonryGridView.builder(
            itemCount: userNotes.length,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemBuilder: (context, index) => InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                // Show options for update or delete
                showModalBottomSheet(
                  context: context,
                  builder: (ctx) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit'),
                          onTap: () {
                            // Navigate to edit page or show a form
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NotesAdd(
                                  note: userNotes[index],
                                ),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Delete'),
                          onTap: () {
                            try {
                              ref
                                  .read(userNoteprovider.notifier)
                                  .deleteNote(userNotes[index].id);
                              Navigator.of(context)
                                  .pop(); // Close the bottom sheet after deletion
                            } catch (e) {
                              // Handle the error, e.g., show a dialog or snackbar
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: NotesItem(
                    image: userNotes[index].image,
                    title: userNotes[index].title,
                    notes: userNotes[index].note),
              ),
            ),
          );
  }
}
