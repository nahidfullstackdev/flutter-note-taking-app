import 'package:flutter/material.dart';

class Folders extends StatelessWidget {
  const Folders({super.key, required this.folderName});

  final String folderName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.folder),
          color: Colors.blueAccent,
          iconSize: 80,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          folderName,
          style: TextStyle(
              color: theme.colorScheme.inversePrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
