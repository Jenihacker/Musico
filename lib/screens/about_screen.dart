import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musico/colors/color.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBody: true,
      appBar: AppBar(backgroundColor: Colors.transparent),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 70,
              child: Text(
                'Musico',
                style: GoogleFonts.poppins(
                    fontSize: 45, fontWeight: FontWeight.w500),
              ),
            ),
            const Center(
              child: CircleAvatar(
                backgroundColor: Color(0XFF1A1A1A),
                radius: 120,
                child: Image(
                  image:
                      AssetImage('assets/images/ic_launcher_adaptive_fore.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Musico is a music player application developed by Jenison Monteiro that fetches music from YouTube API. It\'s an Ad free app.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 16.0),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
                tileColor: const Color(0XFF1e1c22),
                leading: const FaIcon(
                  FontAwesomeIcons.github,
                  color: Colors.white,
                  size: 35.0,
                ),
                title: Text(
                  'Github',
                  style: GoogleFonts.poppins(color: listTitleTextColor),
                ),
                subtitle: Text(
                  'view github profile',
                  style: GoogleFonts.poppins(color: listSubtitleTextColor),
                ),
                onTap: () async {
                  _launchUrl("https://github.com/Jenihacker");
                }),
            ListTile(
                tileColor: const Color(0XFF1e1c22),
                leading: const FaIcon(
                  FontAwesomeIcons.linkedin,
                  color: Color(0XFF0a66c2),
                  size: 40.0,
                ),
                title: Text(
                  'LinkedIn',
                  style: GoogleFonts.poppins(color: listTitleTextColor),
                ),
                subtitle: Text(
                  'view linkedin profile',
                  style: GoogleFonts.poppins(color: listSubtitleTextColor),
                ),
                onTap: () async {
                  _launchUrl(
                      "https://www.linkedin.com/in/jenison-monteiro-7715b0205/");
                }),
            ListTile(
                tileColor: const Color(0XFF1e1c22),
                leading: const FaIcon(
                  FontAwesomeIcons.twitter,
                  color: Color(0XFF1d9bf0),
                  size: 35.0,
                ),
                title: Text(
                  'Twitter',
                  style: GoogleFonts.poppins(color: listTitleTextColor),
                ),
                subtitle: Text(
                  'view twitter profile',
                  style: GoogleFonts.poppins(color: listSubtitleTextColor),
                ),
                onTap: () async {
                  _launchUrl("https://twitter.com/jenisonmonteiro");
                }),
            ListTile(
                tileColor: const Color(0XFF1e1c22),
                leading: const FaIcon(
                  FontAwesomeIcons.instagram,
                  color: Color.fromARGB(255, 252, 1, 80),
                  size: 35.0,
                ),
                title: Text(
                  'Instagram',
                  style: GoogleFonts.poppins(color: listTitleTextColor),
                ),
                subtitle: Text(
                  'view instagram profile',
                  style: GoogleFonts.poppins(color: listSubtitleTextColor),
                ),
                onTap: () async {
                  _launchUrl("https://www.instagram.com/jenison__05/");
                }),
            const SizedBox(
              height: 80,
            )
          ],
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
