import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:musico/colors/color.dart';
import 'package:musico/screens/about_screen.dart';
import 'package:musico/screens/home_screen.dart';
import 'package:musico/screens/player_screen.dart';
import 'package:musico/screens/search_screen.dart';
import 'package:musico/services/Providers/music_player_provider.dart';
import 'package:musico/services/api/player_api.dart';
import 'package:musico/widgets/floating_mediabar.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  var currentIndex = 0;
  List<Widget> widgets = [
    const HomeScreen(),
    const SearchScreen(),
    const AboutScreen()
  ];

  Widget mainBody() {
    switch (currentIndex) {
      case 0:
        return widgets[0];
      case 1:
        return widgets[1];
      case 2:
        return widgets[2];
      default:
        return widgets[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(children: [
            mainBody(),
            Consumer<MusicPlayerProvider>(
                builder: (_, musicPlayerProvider, child) {
              return const Positioned(
                  bottom: 75,
                  child: FloatingMediaBar());
            })
          ]),
          backgroundColor: Colors.transparent,
          extendBody: true,
          bottomNavigationBar: Container(
            margin: const EdgeInsets.only(left: 12.0, right: 12.0),
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  decoration: BoxDecoration(
                    color: const Color(0XFF232123).withAlpha(100),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              currentIndex = 0;
                            });
                          },
                          icon: Icon(
                            Icons.home,
                            color: currentIndex == 0
                                ? Colors.black
                                : Colors.blueGrey,
                          ),
                          style: ButtonStyle(
                            backgroundColor: currentIndex == 0
                                ? const MaterialStatePropertyAll(
                                    primaryThemeColor)
                                : const MaterialStatePropertyAll(
                                    Colors.transparent),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              currentIndex = 1;
                            });
                          },
                          icon: Icon(
                            Icons.search,
                            color: currentIndex == 1
                                ? Colors.black
                                : Colors.blueGrey,
                          ),
                          style: ButtonStyle(
                            backgroundColor: currentIndex == 1
                                ? const MaterialStatePropertyAll(
                                    primaryThemeColor)
                                : const MaterialStatePropertyAll(
                                    Colors.transparent),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              currentIndex = 2;
                            });
                          },
                          icon: Icon(
                            Icons.info,
                            color: currentIndex == 2
                                ? Colors.black
                                : Colors.blueGrey,
                          ),
                          style: ButtonStyle(
                            backgroundColor: currentIndex == 2
                                ? const MaterialStatePropertyAll(
                                    primaryThemeColor)
                                : const MaterialStatePropertyAll(
                                    Colors.transparent),
                          ),
                        )
                      ]),
                ),
              ),
            ),
          )),
    );
  }
}
