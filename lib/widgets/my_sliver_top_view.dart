import 'package:flutter/material.dart';
import 'package:students_note_app/pages/notes/widgets/folder/folders.dart';

class MySliverTopView extends StatelessWidget {
  const MySliverTopView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My folders',
                style: TextStyle(
                  color: theme.colorScheme.inversePrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Filter by',
                style: TextStyle(
                  color: theme.colorScheme.inversePrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Folders(folderName: 'Homework'),
            Folders(folderName: 'Assignment Plan'),
            Folders(folderName: 'Class Events'),
          ],
        ),
      ],
    );
  }
}
