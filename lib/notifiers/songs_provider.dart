import 'package:audio_service/audio_service.dart';
import 'package:dum/services/get_songs.dart';
import 'package:dum/services/song_handler.dart';
import 'package:flutter/material.dart';

// Define a class for managing songs using ChangeNotifier
class SongsProvider extends ChangeNotifier {
  // Private variable to store the list of songs
  List<MediaItem> _songs = [];

  // Getter for accessing the list of songs
  List<MediaItem> get songs => _songs;

  // Private variable to track the loading state
  bool _isLoading = true;

  // Getter for accessing the loading state
  bool get isLoading => _isLoading;

  // Asynchronous method to load songs
  Future<void> loadSongs(SongHandler songHandler) async {
    try {
      // Use the getSongs function to fetch the list of songs
      _songs = await getSongs();

      // Initialize the song handler with the loaded songs
      await songHandler.initSongs(songs: _songs);

      // Update the loading state to indicate completion
      _isLoading = false;

      // Notify listeners about the changes in the state
      notifyListeners();
    } catch (e) {
      // Handle any errors that occur during the process
      debugPrint('Error loading songs: $e');
      // You might want to set _isLoading to false here as well, depending on your use case
    }
  }
}
