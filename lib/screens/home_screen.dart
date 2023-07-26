//import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musico/components/playlist_container.dart';
import 'package:musico/screens/about_screen.dart';
import 'package:musico/screens/search_screen.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var settext = "";
  var currentIndex = 0;

  @override
  void initState() {
    super.initState();
    var time = DateTime.now().hour;
    if (time >= 0 && time < 12) {
      settext = "Good Morning";
    } else if (time >= 12 && time < 17) {
      settext = "Good Afternoon";
    } else if (time >= 17 && time < 21) {
      settext = "Good Evening";
    } else {
      settext = "Good Night";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.topLeft,
                colors: [
              Color(0XFF780206),
              Color(0XFF061161),
            ])),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            toolbarHeight: 65.0,
            backgroundColor: Colors.black26,
            title: Text(
              settext,
              style: GoogleFonts.poppins(
                fontSize: 25.0,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: InkWell(
                  onTap: () => Navigator.push(
                      context,
                      PageTransition(
                          child: const AboutScreen(),
                          type: PageTransitionType.rightToLeft)),
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white70,
                    child: Image(
                      image: AssetImage('assets/images/playstore.png'),
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              )
            ],
          ),
          backgroundColor: Colors.black26,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Chill",
                    style: GoogleFonts.pacifico(
                      fontSize: 30,
                    ),
                  ),
                  const PlaylistContainer(title: "chill"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Commute",
                    style: GoogleFonts.pacifico(
                      fontSize: 30,
                    ),
                  ),
                  const PlaylistContainer(title: "commute"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Energy Booster",
                    style: GoogleFonts.pacifico(
                      fontSize: 30,
                    ),
                  ),
                  const PlaylistContainer(title: "energy booster"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Feel Good",
                    style: GoogleFonts.pacifico(
                      fontSize: 30,
                    ),
                  ),
                  const PlaylistContainer(title: "feel good"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Focus",
                    style: GoogleFonts.pacifico(
                      fontSize: 30,
                    ),
                  ),
                  const PlaylistContainer(title: "focus"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Party",
                    style: GoogleFonts.pacifico(
                      fontSize: 30,
                    ),
                  ),
                  const PlaylistContainer(title: "party"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Romance",
                    style: GoogleFonts.pacifico(
                      fontSize: 30,
                    ),
                  ),
                  const PlaylistContainer(title: "romance"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Sleep",
                    style: GoogleFonts.pacifico(
                      fontSize: 30,
                    ),
                  ),
                  const PlaylistContainer(title: "sleep"),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Workout",
                    style: GoogleFonts.pacifico(
                      fontSize: 30,
                    ),
                  ),
                  const PlaylistContainer(title: "workout"),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.black54,
              elevation: 0,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white,
              onTap: (value) {
                switch (value) {
                  case 0:
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: const HomeScreen()));
                    break;
                  case 1:
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 300),
                            child: const SearchScreen()));
                    break;
                  case 2:
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 300),
                            child: const AboutScreen()));
                    break;
                }
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    label: 'home'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.search_outlined,
                      color: Colors.white,
                    ),
                    label: 'search'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.info_outline,
                    ),
                    label: 'About'),
              ]), /*
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),),
                  child: CurvedNavigationBar(
                      animationDuration: const Duration(milliseconds: 300),
                      onTap: (value) {
                        if (value != currentIndex) {
                          switch (value) {
                            case 0:
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: const HomeScreen()));
                              currentIndex = value;
                              break;
                            case 1:
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: const Duration(milliseconds: 300),
                                      child: const SearchScreen()));
                              currentIndex = value;
                              break;
                            case 2:
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      duration: const Duration(milliseconds: 300),
                                      child: const AboutScreen()));
                              currentIndex = value;
                              break;
                          }
                        }
                      },
                      backgroundColor: Colors.transparent,
                      buttonBackgroundColor: Colors.white,
                      color: Colors.white12,
                      height: MediaQuery.of(context).size.height * 0.07,
                      items: const [
                    Icon(Icons.home),
                    Icon(Icons.search),
                    Icon(Icons.info),
                  ]),
                )*/
        ),
      ),
    );
  }
}
