import 'dart:async';
import 'dart:convert';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:musico/screens/search_results.dart';
import 'package:page_transition/page_transition.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late dynamic message;
  String recognizedText = "";
  bool available = false;
  bool _isListening = false;
  stt.SpeechToText speech = stt.SpeechToText();

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
            debugPrint(recognizedText);
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
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [
            Colors.black,
            Colors.black
            // Color(0XFF780206),
            // Color(0XFF061161),
          ])),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black12,
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50.0,
                    child: Text('Search',
                        style: GoogleFonts.poppins(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  SizedBox(
                      child: TypeAheadField(
                    hideSuggestionsOnKeyboardHide: true,
                    textFieldConfiguration: TextFieldConfiguration(
                      cursorColor: Colors.white,
                      style: GoogleFonts.poppins(
                        fontSize: 20.0,
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: SearchResultScreen(message: value),
                                  type:
                                      PageTransitionType.rightToLeftWithFade));
                        }
                      },
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
                        suffixIcon: IconButton(
                          padding: const EdgeInsets.only(right: 10.0),
                          splashRadius: 10,
                          icon: const Icon(Icons.mic, size: 30.0),
                          onPressed: () {
                            setState(() {
                              _isListening = false;
                            });
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  StatefulBuilder(builder: (context, setState) {
                                return AlertDialog(
                                  backgroundColor: const Color(0XFF1e1c22),
                                  actionsPadding: const EdgeInsets.symmetric(
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
                                          style:
                                              const TextStyle(fontSize: 30.0)),
                                    ),
                                    Center(
                                        child: AvatarGlow(
                                      glowColor: const Color(0XFFC4FC4C),
                                      endRadius: 80.0,
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
                                              const Color(0XFFC4FC4C),
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_none,
                                            size: 40.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ))
                                  ],
                                );
                              }),
                            );
                          },
                          color: Colors.white,
                        ),
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide.none),
                      ),
                      enableSuggestions: true,
                    ),
                    suggestionsCallback: (pattern) async {
                      return await getsuggestion(pattern);
                      //return ['Song not found'];
                    },
                    itemBuilder: (context, itemData) {
                      return Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.topLeft,
                                colors: [
                              //Color(0XFF000000),
                              // Color.fromARGB(223, 109, 2, 6),
                              // Color.fromARGB(223, 5, 15, 86),
                              Color(0XFF1e1c22),
                              Color(0XFF1e1c22)
                              //Color(0XFF000000),
                            ])),
                        child: ListTile(
                          leading: const Icon(Icons.music_note_outlined,
                              color: Colors.white),
                          title: Text(
                            itemData,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                            ),
                          ),
                          tileColor: Colors.transparent,
                        ),
                      );
                    },
                    getImmediateSuggestions: true,
                    minCharsForSuggestions: 1,
                    loadingBuilder: (context) {
                      return const CircularProgressIndicator();
                    },
                    hideOnLoading: true,
                    onSuggestionSelected: (suggestion) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return SearchResultScreen(message: suggestion);
                        },
                      ));
                    },
                    hideOnError: true,
                    hideOnEmpty: true,
                  )),
                ])),
      ),
    ));
  }

  Future<List<dynamic>> getsuggestion(String pattern) async {
    final response = await http.get(Uri.parse(
        'https://ytmusic-tau.vercel.app/search_suggestion?query=$pattern'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      return data['suggestions'];
    }
    return [];
  }
}
