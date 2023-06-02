import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_player/screens/search_screen.dart';

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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 90.0,
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
      backgroundColor: const Color(0XFF242424),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
              boxShadow: [BoxShadow(color: Color(0XFF1F1545))]),
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
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const HomeScreen();
                  },
                ));
                break;
              case 1:
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const SearchScreen();
                  },
                ));
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
    );
  }
}
