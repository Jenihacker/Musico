//import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musico/components/playlist_container.dart';
import 'package:musico/screens/about_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var settext = "";
  late final SharedPreferences pref;
  String username = "";
  String? avatar;

  void getsharedpref() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString('username') ?? "";
      avatar = pref.getString('avatar');
    });
  }

  @override
  void initState() {
    super.initState();
    getsharedpref();
    var time = DateTime.now().hour;
    if (time >= 0 && time < 12) {
      settext = "Good morning";
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
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              colors: [
            Color(0XFF000000),
            Color(0XFF000000),
            // Color(0XFF780206),
            // Color(0XFF061161),
          ])),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.black,
          toolbarHeight: 65.0,
          title: Text(
            "$settext ${username!}",
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
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
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0XFF1A1A1A),
                  backgroundImage: AssetImage(
                      avatar ?? 'assets/images/ic_launcher_adaptive_fore.png'),
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
                const SizedBox(
                  height: 80,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
