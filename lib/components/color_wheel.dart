import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state_management/note_provider.dart';

class ColorWheel extends StatelessWidget {
  const ColorWheel({
    required this.color,
    super.key,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    NoteProvider value = context.watch<NoteProvider>();
    return GestureDetector(
      onTap: () {
        value.changeNoteTextColr(color);
      },
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: value.noteTextColor == color ? Colors.grey.shade300 : color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: value.noteTextColor == color
            ? const Icon(
                Icons.check,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
