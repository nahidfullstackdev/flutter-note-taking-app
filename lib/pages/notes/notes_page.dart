import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:students_note_app/pages/notes/widgets/note_list.dart';
import 'package:students_note_app/services/providers/notes_provider.dart';
import 'package:students_note_app/widgets/my_sliver_appbar.dart';
import 'package:students_note_app/widgets/my_sliver_top_view.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesFuture = ref.watch(userNoteprovider.notifier).loadNotes();
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const MySliverAppbar(
            // Folders row

            title: Text(
              'Recent Note',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            // Folders row

            child: // My folders
                MySliverTopView(),
          ),
        ],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            height: screenSize.height,
            child: FutureBuilder(
              future: notesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  return const NoteList();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
