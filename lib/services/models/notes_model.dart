import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class NotesModel {
  NotesModel({
    required this.image,
    required this.title,
    required this.note,
 
    String? id,
  }) : id = id ?? uuid.v4();

  final File image;
  final String title;
  final String note;
  final String id;
 

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'image': image.path,
      
    };
  }

  factory NotesModel.fromMap(Map<String, dynamic> map) {
    return NotesModel(
      id: map['id'] ?? uuid.v4(),
      title: map['title'],
      note: map['note'],
      image: File(map['image']),
      
    );
  }
}
