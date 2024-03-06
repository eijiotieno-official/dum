// Import necessary packages and files
import 'package:dum/notifiers/songs_provider.dart';
import 'package:dum/services/song_handler.dart';
import 'package:dum/ui/components/player_deck.dart';
import 'package:dum/ui/components/songs_list.dart';
import 'package:dum/ui/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

// Define the HomeScreen class, a StatefulWidget
class HomeScreen extends StatefulWidget {
  final SongHandler songHandler;

  // Constructor to receive a SongHandler instance
  const HomeScreen({super.key, required this.songHandler});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Define the state class for HomeScreen
class _HomeScreenState extends State<HomeScreen> {
  // Create an AutoScrollController for smooth scrolling
  final AutoScrollController _autoScrollController = AutoScrollController();

  // Method to scroll to a specific index in the song list
  void _scrollTo(int index) {
    _autoScrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.middle,
      duration: const Duration(milliseconds: 800),
    );
  }

  // Build method for the HomeScreen widget
  @override
  Widget build(BuildContext context) {
    // Annotate the UI overlay style for system UI elements
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.background,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
      ),
      child: Consumer<SongsProvider>(
        builder: (context, songsProvider, _) {
          // Scaffold widget for the app structure
          return Scaffold(
            appBar: AppBar(
              title: const Text("Dum"),
              actions: [
                // IconButton to navigate to the SearchScreen
                IconButton(
                  onPressed: () => Get.to(
                    () => SearchScreen(songHandler: widget.songHandler),
                    duration: const Duration(milliseconds: 700),
                    transition: Transition.rightToLeft,
                  ),
                  icon: const Icon(
                    Icons.search_rounded,
                  ),
                ),
              ],
            ),
            body: songsProvider.isLoading
                ? _buildLoadingIndicator() // Display a loading indicator while songs are loading
                : _buildSongsList(songsProvider), // Display the list of songs
          );
        },
      ),
    );
  }

  // Method to build the loading indicator widget
  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        strokeCap: StrokeCap.round,
      ),
    );
  }

  // Method to build the main songs list with a player deck
  Widget _buildSongsList(SongsProvider songsProvider) {
    return Stack(
      children: [
        // SongsList widget to display the list of songs
        SongsList(
          songHandler: widget.songHandler,
          songs: songsProvider.songs,
          autoScrollController: _autoScrollController,
        ),
        _buildPlayerDeck(), // PlayerDeck widget for music playback controls
      ],
    );
  }

  // Method to build the player deck widget
  Widget _buildPlayerDeck() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // PlayerDeck widget with controls and the ability to scroll to a specific song
        PlayerDeck(
          songHandler: widget.songHandler,
          isLast: false,
          onTap: _scrollTo,
        ),
      ],
    );
  }
}
