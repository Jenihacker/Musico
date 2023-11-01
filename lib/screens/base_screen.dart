import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:musico/screens/about_screen.dart';
import 'package:musico/screens/home_screen.dart';
import 'package:musico/screens/player_screen.dart';
import 'package:musico/screens/search_screen.dart';
import 'package:musico/services/Providers/music_player_provider.dart';
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

  Widget mainbody() {
    switch (currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const SearchScreen();
      case 2:
        return const AboutScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        mainbody(),
        Consumer<MusicPlayerProvider>(builder: (_, musicPlayerProvider, child) {
          return Positioned(
              bottom: 65,
              child: Visibility(
                visible: musicPlayerProvider.audio == null ? false : true,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                      color: const Color(0XFFC4FC4C),
                      borderRadius: BorderRadius.circular(10.0)),
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: ListTile(
                        title: Text(
                          musicPlayerProvider
                              .title[musicPlayerProvider.currentIndex],
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          musicPlayerProvider
                              .author[musicPlayerProvider.currentIndex],
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image(
                            image: NetworkImage(musicPlayerProvider
                                .thumbnail[musicPlayerProvider.currentIndex]),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              iconSize: 35,
                              icon: musicPlayerProvider.isPlaying
                                  ? const Icon(
                                      Icons.pause,
                                      size: 35,
                                      color: Colors.black,
                                    )
                                  : const Icon(
                                      Icons.play_arrow,
                                      size: 35,
                                      color: Colors.black,
                                    ),
                              onPressed: () {
                                musicPlayerProvider.togglePlayback();
                              },
                            ),
                            Visibility(
                              visible:
                                  musicPlayerProvider.advancedPlayer.hasNext
                                      ? true
                                      : false,
                              child: IconButton(
                                iconSize: 35,
                                icon: const Icon(
                                  Icons.skip_next,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  musicPlayerProvider.playNextSong();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const PlayerScreen(),
                              type: PageTransitionType.bottomToTop));
                    },
                  ),
                ),
              ));
        })
      ]),
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Colors.transparent),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: NavigationBar(
                height: 60,
                backgroundColor: Colors.white38,
                selectedIndex: currentIndex,
                onDestinationSelected: (value) {
                  if (currentIndex != value) {
                    setState(() {
                      currentIndex = value;
                    });
                  }
                },
                indicatorColor: const Color(0XFFC4FC4C),
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                  NavigationDestination(
                      icon: Icon(Icons.search), label: 'Search'),
                  NavigationDestination(icon: Icon(Icons.info), label: 'About')
                ]),
          ),
        ),
      ),
      // bottomNavigationBar: Container(
      //     decoration: const BoxDecoration(
      //         gradient: LinearGradient(
      //             begin: Alignment.topRight,
      //             end: Alignment.bottomLeft,
      //             colors: [
      //           //Color(0XFF000000),
      //           //Color(0XFF000000),
      //           Color(0XFF780206),
      //           Color(0XFF061161),
      //         ])),
      // child: BottomNavigationBar(
      //     currentIndex: currentIndex,
      //     selectedFontSize: 12.0,
      //     type: BottomNavigationBarType.fixed,
      //     backgroundColor: Colors.black12,
      //     elevation: 0,
      //     selectedItemColor: Colors.white,
      //     unselectedItemColor: Colors.white54,
      //     onTap: (value) {
      //       setState(() {
      //         currentIndex = value;
      //       });
      //     },
      //     items: const [
      //       BottomNavigationBarItem(
      //           activeIcon: Icon(BootstrapIcons.house_fill),
      //           icon: Icon(
      //             BootstrapIcons.house,
      //             color: Colors.grey,
      //           ),
      //           label: 'Home'),
      //       BottomNavigationBarItem(
      //           icon: Icon(
      //             BootstrapIcons.search,
      //           ),
      //           label: 'Search'),
      //       BottomNavigationBarItem(
      //           activeIcon: Icon(BootstrapIcons.info_circle_fill),
      //           icon: Icon(
      //             BootstrapIcons.info_circle,
      //           ),
      //           label: 'About'),
      //     ]),
      // child: ),
    ));
  }
}
