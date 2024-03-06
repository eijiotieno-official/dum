import 'package:audio_service/audio_service.dart';
import 'package:dum/notifiers/songs_provider.dart';
import 'package:dum/services/song_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:get/get.dart';

import 'ui/screens/home_screen.dart';

// Create a singleton instance of SongHandler
SongHandler _songHandler = SongHandler();

// Entry point of the application
Future<void> main() async {
  // Ensure that the Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AudioService with the custom SongHandler
  _songHandler = await AudioService.init(
    builder: () => SongHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.dum.app',
      androidNotificationChannelName: 'Dum Player',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
    ),
  );

  // Run the application
  runApp(
    MultiProvider(
      providers: [
        // Provide the SongsProvider with the loaded songs and SongHandler
        ChangeNotifierProvider(
          create: (context) => SongsProvider()..loadSongs(_songHandler),
        ),
      ],
      // Use the MainApp widget as the root of the application
      child: const MainApp(),
    ),
  );

  // Set preferred orientations for the app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

// Root application widget
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Build the app using DynamicColorBuilder
    return DynamicColorBuilder(
      builder: (ColorScheme? light, ColorScheme? dark) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          // Configure the theme with light and dark color schemes
          theme: ThemeData(
            colorScheme: light,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: dark,
            useMaterial3: true,
          ),
          // Set HomeScreen as the initial screen with the provided SongHandler
          home: HomeScreen(songHandler: _songHandler),
        );
      },
    );
  }
}
