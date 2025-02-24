import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:musico/colors/color.dart';
import 'package:musico/screens/base_screen.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  List<String> avatars = [
    'assets/avatars/cartoonish-3d-animation-boy-glasses-with-blue-hoodie-orange-shirt_899449-25777.jpg',
    'assets/avatars/7309681.jpg',
    'assets/avatars/9334243.jpg',
    'assets/avatars/3d-illustration-human-avatar-profile_23-2150671128.jpg',
    'assets/avatars/9440461.jpg',
    'assets/avatars/3d-illustration-human-avatar-profile_23-2150671126.jpg',
    'assets/avatars/3d-illustration-human-avatar-profile_23-2150671122.jpg',
    'assets/avatars/3d-illustration-human-avatar-profile_23-2150671138.jpg',
    'assets/avatars/3d-illustration-human-avatar-profile_23-2150671159.jpg',
    'assets/avatars/3d-illustration-person-with-glasses_23-2149436191.jpg',
    'assets/avatars/3d-illustration-person-with-sunglasses_23-2149436178.jpg',
    'assets/avatars/3d-illustration-person-with-sunglasses_23-2149436180.jpg',
    'assets/avatars/3d-rendering-boy-avatar-emoji_23-2150603408.jpg',
  ];
  int currentAvatar = 0;
  String username = "";
  late final Box avatarBox;


  @override
  void initState() {
    super.initState();
    initializaHive();
  }

  void initializaHive() async {
    avatarBox = await Hive.openBox('avatarBox');
  }

  void setAvatar() async {
    await avatarBox.put('username', username);
    await avatarBox.put('avatar', avatars[currentAvatar]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
                child: Text(
                  'Your Profile',
                  style: GoogleFonts.poppins(fontSize: 20.0),
                ),
              ),
              CircleAvatar(
                radius: 70,
                backgroundColor: const Color(0XFF1A1A1A),
                backgroundImage: AssetImage(avatars[currentAvatar]),
                child: Stack(
                  children: [
                    Positioned(
                      right: 10,
                      bottom: 5,
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: primaryThemeColor,
                            borderRadius: BorderRadius.circular(50.0)),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                    style: GoogleFonts.poppins(),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                        filled: true,
                        label: const Text('Username',
                            style: TextStyle(color: Colors.white)),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: primaryThemeColor),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: primaryThemeColor),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: primaryThemeColor),
                        ),
                        fillColor: const Color(0XFF1e1c22),
                        hintText: 'Enter your username',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.white,
                        ))),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                height: MediaQuery.of(context).size.height * 0.23,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                  itemCount: avatars.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 20,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        if (currentAvatar != index) {
                          setState(() {
                            currentAvatar = index;
                          });
                        }
                      },
                      child: currentAvatar == index
                          ? Container(
                              padding: const EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  border: Border.all(
                                      color: primaryThemeColor, width: 3)),
                              child: CircleAvatar(
                                backgroundImage: AssetImage(avatars[index]),
                              ),
                            )
                          : CircleAvatar(
                              backgroundImage: AssetImage(avatars[index]),
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if (username != "") {
                      setAvatar();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BaseScreen(),
                          ));
                    }
                  },
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0))),
                      minimumSize:
                          const MaterialStatePropertyAll(Size(300, 50)),
                      backgroundColor: username == ""
                          ? const MaterialStatePropertyAll(Colors.grey)
                          : const MaterialStatePropertyAll(primaryThemeColor)),
                  child: Text(
                    'Submit',
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  )) //
            ],
          ),
        ),
      ),
    );
  }
}
