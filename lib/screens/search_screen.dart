import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:musico/colors/color.dart';
import 'package:musico/screens/search_results.dart';
import 'package:musico/services/api/search_suggestions_api.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String message = "";
  String recognizedText = "";
  bool available = false;
  bool _isListening = false;
  stt.SpeechToText speech = stt.SpeechToText();
  late final SharedPreferences prefs;
  late final SuggestionsController suggestionsController;
  bool isHistory = false;

  @override
  void initState() {
    super.initState();
    getsharedpref();
    suggestionsController = SuggestionsController();
  }

  void getsharedpref() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> sethistory(String historyItem) async {
    List<String> history = prefs.getStringList('history') ?? [];
    if (!history.contains(historyItem)) {
      history.add(historyItem);
      await prefs.setStringList('history', history);
    } else {
      history.remove(historyItem);
      history.add(historyItem);
      await prefs.setStringList('history', history);
    }
  }

  Future<List<String>> gethistory() async {
    List<String> history = prefs.getStringList('history') ?? [];
    return history.reversed.toList();
  }

  Future<void> deleteHistoryItem(String historyItem) async {
    List<String> history = prefs.getStringList('history') ?? [];
    history.remove(historyItem);
    await prefs.setStringList('history', history);
  }

  Future<void> listenSpeech(setState) async {
    if (!available) {
      available = await speech.initialize();
    }
    if (available) {
      setState(() {
        recognizedText = "";
      });
      speech.listen(
        onResult: (result) {
          setState(() {
            recognizedText = result.recognizedWords;
          });
          super.setState(() {
            message = result.recognizedWords;
          });
        },
      );
      speech.statusListener = (status) {
        if (status == 'listening') {
          setState(() => _isListening = true);
        }
        if (status == 'notListening') {
          setState(() => _isListening = false);
        }
        if (status == 'done') {
          if (recognizedText.isNotEmpty) {
            Navigator.pop(context);
            Navigator.push(
                context,
                PageTransition(
                    child: SearchResultScreen(message: recognizedText),
                    type: PageTransitionType.rightToLeft));
          }
          setState(() {
            _isListening = false;
            recognizedText = "";
          });
        }
      };
    } else {
      setState(() {
        _isListening = false;
        recognizedText = "Can't Recognize\nVoice";
      });
    }
  }

  void stopSpeech(setState) {
    if (available) {
      speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          toolbarHeight: 40,
        ),
        backgroundColor: Colors.black12,
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 65.0,
                    child: Text('Search',
                        style: GoogleFonts.poppins(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  SizedBox(
                      child: TypeAheadField(
                    hideOnLoading: true,
                    controller: TextEditingController(text: message),
                    builder: (context, controller, focusNode) {
                      return TextField(
                        cursorColor: Colors.white,
                        style: GoogleFonts.poppins(
                          fontSize: 20.0,
                        ),
                        focusNode: focusNode,
                        enableSuggestions: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0XFF1e1c22),
                          hintText: 'Search',
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 5.0),
                            child: Icon(
                              BootstrapIcons.search,
                              color: Colors.white,
                            ),
                          ),
                          hintStyle: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: IconButton(
                            padding: const EdgeInsets.only(right: 10.0),
                            splashRadius: 10,
                            color: iconColor,
                            onPressed: () {
                              setState(() {
                                _isListening = false;
                              });
                              showDialog(
                                context: context,
                                builder: (context) => StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      backgroundColor: const Color(0XFF1e1c22),
                                      actionsPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 40.0),
                                      title: Text('Tap To Speak',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.poppins(
                                            fontSize: 30.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      actionsAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      actions: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Text(recognizedText,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 30.0)),
                                        ),
                                        Center(
                                            child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: AvatarGlow(
                                            glowColor: primaryThemeColor,
                                            animate: _isListening,
                                            repeat: true,
                                            child: InkWell(
                                              overlayColor:
                                                  const MaterialStatePropertyAll(
                                                      Colors.transparent),
                                              onTap: () async {
                                                setState((() {
                                                  _isListening = !_isListening;
                                                }));
                                                if (_isListening) {
                                                  listenSpeech(setState);
                                                } else {
                                                  stopSpeech(setState);
                                                }
                                              },
                                              child: CircleAvatar(
                                                radius: 40.0,
                                                backgroundColor:
                                                    primaryThemeColor,
                                                child: Icon(
                                                  _isListening
                                                      ? Icons.mic
                                                      : Icons.mic_none,
                                                  size: 40.0,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ))
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                            icon: const Icon(Icons.mic, size: 30.0),
                          ),
                        ),
                        controller: controller,
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            sethistory(value.toString());
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: SearchResultScreen(message: value),
                                    type: PageTransitionType
                                        .rightToLeftWithFade));
                          }
                        },
                      );
                    },
                    decorationBuilder: (context, child) {
                      return Material(
                        type: MaterialType.card,
                        color: const Color(0XFF1e1c22),
                        elevation: 4,
                        borderRadius: BorderRadius.circular(20),
                        child: child,
                      );
                    },
                    suggestionsController: suggestionsController,
                    itemBuilder: (context, value) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: const LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.topLeft,
                                colors: [
                                  Color(0XFF1e1c22),
                                  Color(0XFF1e1c22),
                                ])),
                        child: ListTile(
                          leading: isHistory
                              ? const Icon(
                                  Icons.history,
                                  color: Colors.white,
                                )
                              : const Icon(Icons.music_note_outlined,
                                  color: Colors.white),
                          title: Text(
                            value,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                            ),
                          ),
                          tileColor: Colors.transparent,
                          trailing: Visibility(
                            visible: isHistory,
                            child: IconButton(
                                onPressed: () {
                                  deleteHistoryItem(value);
                                  suggestionsController.refresh();
                                },
                                icon: const Icon(BootstrapIcons.x,
                                    color: Colors.white)),
                          ),
                        ),
                      );
                    },
                    onSelected: (value) {
                      setState(() {
                        message = value;
                      });
                      sethistory(value.toString());
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return SearchResultScreen(message: value.toString());
                        },
                      ));
                    },
                    suggestionsCallback: (search) async {
                      if (search.isEmpty) {
                        isHistory = true;
                        return gethistory();
                      }
                      isHistory = false;
                      return await SearchSuggestionApi()
                              .getSuggestion(search) ??
                          [];
                    },
                  )),
                ])),
      ),
    ));
  }
}
