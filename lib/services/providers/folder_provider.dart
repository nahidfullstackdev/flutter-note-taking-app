import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:students_note_app/services/models/folder_model.dart';

final folderProvider =
    StateNotifierProvider<FolderNotifier, List<FolderModel>>((ref) {
  return FolderNotifier();
});

class FolderNotifier extends StateNotifier<List<FolderModel>> {
  FolderNotifier() : super([]);

  void addFolder(String name) {
    final newFolder = FolderModel(id: DateTime.now().toString(), name: name);
    state = [...state, newFolder];
  }

  void removeFolder(String id) {
    state = state.where((folder) => folder.id != id).toList();
  }
}
