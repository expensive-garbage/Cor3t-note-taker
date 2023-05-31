import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  TextEditingController noteController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  double fontSize = 16;

  final String bulletin = "    \u25ef ";
  List links = [];

  List checkForLinks(String value) {
    List<String> words = value.split(' ');
    RegExp exp = RegExp(r"\b(https?|ftp|file):\/\/\S+|www\.\S+\.\b");

    List matches = words.where((item) => exp.hasMatch(item)).toList();
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Note View'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Focus(
              onKey: (node, event) {
                if (event.logicalKey == LogicalKeyboardKey.backspace) {
                  print('backspace');
                  return KeyEventResult.ignored;
                }
                return KeyEventResult.skipRemainingHandlers;
              },
              child: TextField(
                controller: noteController,
                maxLength: null,
                maxLines: 100,
                onChanged: (value) {
                  setState(() {
                    links = checkForLinks(value);
                  });
                  print(noteController.selection.baseOffset);
                },
                style: TextStyle(fontSize: fontSize),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    border: InputBorder.none),
                maxLengthEnforcement: MaxLengthEnforcement.none,
              ),
            ),
          ),
          links.isNotEmpty
              ? ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 35),
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: links.length,
                      itemBuilder: (context, index) {
                        return Center(
                            child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                          decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(
                            links[index],
                            style: TextStyle(color: Colors.white),
                          ),
                        ));
                      }),
                )
              : SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        fontSize++;
                      });
                    },
                    child: Text(
                      'A',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    )),
                TextButton(
                    onPressed: () {
                      setState(() {
                        fontSize--;
                      });
                    },
                    child: Text(
                      'A',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    )),
                IconButton(
                    onPressed: () {
                      if (noteController.text.isEmpty) {
                        noteController.text = " $bulletin ";
                      } else {
                        if (noteController.text.endsWith('\n')) {
                          noteController.text =
                              "${noteController.text} $bulletin";
                        } else {
                          noteController.text =
                              "${noteController.text} \n $bulletin";
                        }
                      }
                      print(noteController.selection.baseOffset);
                      noteController.selection = TextSelection.fromPosition(
                          TextPosition(offset: noteController.text.length));
                    },
                    icon: Icon(Icons.format_list_bulleted_rounded)),
                IconButton(
                    onPressed: () {
                      scaffoldKey.currentState!.showBottomSheet(
                          (context) => FormatNoteWidget(),
                          enableDrag: false);
                    },
                    icon: Icon(Icons.edit))
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FormatNoteWidget extends StatelessWidget {
  const FormatNoteWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: 100,
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Note Format',
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.close))
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ColorWheel(color: Colors.black),
            ColorWheel(color: Colors.white),
            ColorWheel(color: Colors.blue),
            ColorWheel(color: Colors.red),
            ColorWheel(color: Colors.green),
            ColorWheel(color: Colors.yellow),
          ],
        )
      ]),
    );
  }
}

class ColorWheel extends StatelessWidget {
  const ColorWheel({
    required this.color,
    super.key,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(30)),
    );
  }
}
