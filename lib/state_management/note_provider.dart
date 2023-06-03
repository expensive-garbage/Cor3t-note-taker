import 'package:flutter/material.dart';

class NoteProvider extends ChangeNotifier {
  Color noteTextColor = Colors.black;
  String noteTextFont = 'Cursive';
  double noteTextSize = 14;

  void changeNoteTextColr(Color color) {
    noteTextColor = color;
    notifyListeners();
  }

  void changeNoteTextFont(String font) {
    noteTextFont = font;
    notifyListeners();
  }

  void incrementNoteTextSize() {
    if (noteTextSize <= 32) {
      noteTextSize++;
      notifyListeners();
    }
  }

  void decrementNoteTextSize() {
    if (noteTextSize >= 12) {
      noteTextSize--;
      notifyListeners();
    }
  }
}
