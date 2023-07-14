import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 39, 47, 52),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      backgroundColor: const Color(0XFF16222A),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              SizedBox(
                height: 70,
                child: Text(
                  'Musico',
                  style: GoogleFonts.audiowide(
                      fontSize: 45, fontWeight: FontWeight.w500),
                ),
              ),
              const Center(
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 130,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Image(
                      image: AssetImage('assets/images/playstore.png'),
                      width: 200,
                      height: 200,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Musico is a music player application developed by Jenison Monteiro that fetches music from YouTube API. It\'s an Ad free app.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 16.0),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                  leading: const FaIcon(
                    FontAwesomeIcons.github,
                    color: Colors.white,
                    size: 35.0,
                  ),
                  title: Text(
                    'Github',
                    style: GoogleFonts.poppins(),
                  ),
                  subtitle: Text(
                    'view github profile',
                    style: GoogleFonts.poppins(),
                  ),
                  onTap: () async {
                    _launchUrl("https://github.com/Jenihacker");
                  }),
              ListTile(
                  leading: const FaIcon(
                    FontAwesomeIcons.linkedin,
                    color: Color(0XFF0a66c2),
                    size: 35.0,
                  ),
                  title: Text(
                    'LinkedIn',
                    style: GoogleFonts.poppins(),
                  ),
                  subtitle: Text(
                    'view linkedin profile',
                    style: GoogleFonts.poppins(),
                  ),
                  onTap: () async {
                    _launchUrl(
                        "https://www.linkedin.com/in/jenison-monteiro-7715b0205/");
                  }),
              ListTile(
                  leading: const FaIcon(
                    FontAwesomeIcons.twitter,
                    color: Color(0XFF1d9bf0),
                    size: 35.0,
                  ),
                  title: Text(
                    'Twitter',
                    style: GoogleFonts.poppins(),
                  ),
                  subtitle: Text(
                    'view twitter profile',
                    style: GoogleFonts.poppins(),
                  ),
                  onTap: () async {
                    _launchUrl("https://twitter.com/jenisonmonteiro");
                  }),
              ListTile(
                  leading: const FaIcon(
                    FontAwesomeIcons.instagram,
                    color: Color.fromARGB(255, 252, 1, 80),
                    size: 35.0,
                  ),
                  title: Text(
                    'Instagram',
                    style: GoogleFonts.poppins(),
                  ),
                  subtitle: Text(
                    'view instagram profile',
                    style: GoogleFonts.poppins(),
                  ),
                  onTap: () async {
                    _launchUrl("https://www.instagram.com/jenison__05/");
                  })
            ],
          ),
        ),
      ),
    ));
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url),
        mode: LaunchMode.externalNonBrowserApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
