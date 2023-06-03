import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notetaker/state_management/note_provider.dart';
import 'package:provider/provider.dart';

import '../components/components.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  TextEditingController noteController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  double fontSize = 16;

  ValueNotifier<bool> edit = ValueNotifier(false);

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
    return Consumer<NoteProvider>(builder: (context, provider, _) {
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Note View'),
        ),
        body: Stack(
          children: [
            Column(
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
                      style: TextStyle(
                          fontSize: provider.noteTextSize,
                          color: provider.noteTextColor,
                          fontFamily: provider.noteTextFont),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 4),
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
                            provider.incrementNoteTextSize();
                          },
                          child: const Text(
                            'A',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          )),
                      TextButton(
                          onPressed: () {
                            provider.decrementNoteTextSize();
                          },
                          child: Text(
                            'A',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700),
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

                            noteController.selection =
                                TextSelection.fromPosition(TextPosition(
                                    offset: noteController.text.length));
                          },
                          icon: Icon(Icons.format_list_bulleted_rounded)),
                      IconButton(
                          onPressed: () {
                            edit.value = true;
                            // scaffoldKey.currentState!.showBottomSheet(
                            //     (context) =>
                            //         FormatNoteWidget(provider: provider),
                            //     enableDrag: false);
                          },
                          icon: Icon(Icons.edit))
                    ],
                  ),
                )
              ],
            ),
            ValueListenableBuilder<Object>(
                valueListenable: edit,
                builder: (context, value, _) {
                  return AnimatedPositioned(
                      duration: Duration(milliseconds: 200),
                      bottom: value == false ? -200 : 0,
                      left: 0,
                      right: 0,
                      child: FormatNoteWidget(
                        provider: provider,
                        onClose: () {
                          edit.value = false;
                        },
                      ));
                })
          ],
        ),
      );
    });
  }
}
