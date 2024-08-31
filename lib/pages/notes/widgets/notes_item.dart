import 'dart:io';

import 'package:flutter/material.dart';

class NotesItem extends StatelessWidget {
  const NotesItem(
      {super.key,
      required this.image,
      required this.title,
      required this.notes});

  final File image;
  final String title;
  final String notes;

  @override
  Widget build(BuildContext context) {
    // final screenSize = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // image
          SizedBox(
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          ////////////////////////////////////////////////////////
          const SizedBox(
            height: 5,
          ),
          // text part
          Container(
            padding: const EdgeInsets.all(12),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                //title
                Text(
                  title,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 12,
                ),

                // users note
                Text(
                  notes,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
