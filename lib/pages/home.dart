import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:students_note_app/pages/notes/notes_page.dart';
import 'package:students_note_app/pages/notes/widgets/notes_add.dart';
import 'package:students_note_app/services/models/notes_model.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int selectedIndex = 0;

  PageController pageController = PageController();

  void onTaped(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  void _openAddNoteScreen(NotesModel? note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NotesAdd(note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xfff8f8f8),

        body: PageView(
          controller: pageController,
          children: [
            const NotesPage(),
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(color: Colors.amber),
              child: const Center(
                child: Text('Search'),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(color: Colors.greenAccent),
              child: const Center(
                child: Text('Calender'),
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(color: Colors.black54),
              child: const Center(
                child: Text('Profile'),
              ),
            ),
          ],
        ),

        // Bottom Navigation.......................
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: onTaped,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.note), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
              BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.people), label: ''),
            ]),
///////////////////////////////////////////////////////////////////////////

        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.miniCenterDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: theme.colorScheme.inverseSurface,
          elevation: 20,
          shape: const CircleBorder(),
          onPressed: () => _openAddNoteScreen(null),
          child: Icon(
            Icons.add,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
