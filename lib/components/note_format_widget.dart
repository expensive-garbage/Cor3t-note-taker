import 'package:flutter/material.dart';
import 'package:notetaker/state_management/note_provider.dart';
import 'package:provider/provider.dart';

import 'color_wheel.dart';

class FormatNoteWidget extends StatelessWidget {
  const FormatNoteWidget({
    required this.provider,
    required this.onClose,
    super.key,
  });

  final NoteProvider? provider;
  final Function() onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Note Format',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.withOpacity(.5),
                    padding: EdgeInsets.all(4),
                  ),
                  constraints: BoxConstraints(),
                  onPressed: onClose,
                  icon: Icon(
                    Icons.close_outlined,
                  ))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 15),
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 60),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: fonts.length,
                itemBuilder: (context, index) {
                  return FontSelect(font: fonts[index]);
                },
              )),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColorWheel(color: Colors.black),
              ColorWheel(color: Colors.white),
              ColorWheel(color: Colors.blue),
              ColorWheel(color: Colors.red),
              ColorWheel(color: Colors.green),
              ColorWheel(color: Colors.yellow),
            ],
          ),
        )
      ]),
    );
  }
}

class SelectFontModel {
  String? font;

  SelectFontModel({this.font});
}

List<String> fonts = [
  'Cursive',
  'Gothic',
  'Montserrat',
  'Roboto',
  'Times New Roman'
];

class FontSelect extends StatelessWidget {
  const FontSelect({required this.font, super.key});

  final String font;

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteProvider>(builder: (context, value, _) {
      return TextButton(
          onPressed: () {
            value.changeNoteTextFont(font);
          },
          style: value.noteTextFont == font
              ? TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10))
              : null,
          child: Center(
            child: Text(
              font,
              style: TextStyle(
                  fontFamily: font,
                  fontSize: 20,
                  color:
                      value.noteTextFont == font ? Colors.white : Colors.black),
            ),
          ));
    });
  }
}
