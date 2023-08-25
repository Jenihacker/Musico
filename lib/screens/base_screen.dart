import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:musico/screens/about_screen.dart';
import 'package:musico/screens/home_screen.dart';
import 'package:musico/screens/search_screen.dart';

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
      body: mainbody(),
      backgroundColor: Colors.transparent,
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50.0),
            color: Colors.transparent),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.0),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: NavigationBar(
                height: 60,
                backgroundColor: Colors.white38,
                selectedIndex: currentIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    currentIndex = value;
                  });
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
