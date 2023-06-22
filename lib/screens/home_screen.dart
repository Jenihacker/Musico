import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/components/playlist_container.dart';
import 'package:music_player/screens/search_screen.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var settext = "";

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
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          toolbarHeight: 65.0,
          backgroundColor: const Color(0XFF1F1545),
          title: Text(
            settext,
            style: GoogleFonts.poppins(
              fontSize: 25.0,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
            ),
            IconButton(
              icon: const Icon(Icons.timer),
              onPressed: () {},
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
            )
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 17, 11, 43),
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
            backgroundColor: const Color(0XFF1F1545),
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
                          duration: const Duration(milliseconds: 400),
                          child: const SearchScreen()));
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
                    Icons.search,
                    color: Colors.white,
                  ),
                  label: 'search'),
            ]),
      ),
    );
  }
}
