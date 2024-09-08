import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:musico/screens/base_screen.dart';
import 'package:musico/screens/wrapper.dart';
import 'package:musico/services/Providers/music_player_provider.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Box avatarBox = await Hive.openBox('avatarBox');
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
    androidStopForegroundOnPause: true,
  );
  runApp(MyApp(
    avatarBox: avatarBox,
  ));
}

class MyApp extends StatefulWidget {
  final Box avatarBox;

  const MyApp({super.key, required this.avatarBox});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MusicPlayerProvider(),
        )
      ],
      child: GetMaterialApp(
        title: 'Musico',
        debugShowCheckedModeBanner: false,
        color: Colors.white,
        theme: ThemeData(
          primaryColor: Colors.white,
          primarySwatch: Colors.deepPurple,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
        ),
        home: UpgradeAlert(
          upgrader: Upgrader(),
          child: widget.avatarBox.get('username') == null &&
                  widget.avatarBox.get('avatar') == null
              ? const Wrapper()
              : const BaseScreen(),
        ),
      ),
    );
  }
}
