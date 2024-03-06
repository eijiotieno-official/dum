import 'package:audio_service/audio_service.dart';
import 'package:dum/services/request_song_permission.dart';
import 'package:dum/services/song_to_media_item.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

// Asynchronous function to get a list of MediaItems representing songs
Future<List<MediaItem>> getSongs() async {
  try {
    // Ensure that the necessary permissions are granted
    await requestSongPermission();

    // List to store the MediaItems representing songs
    final List<MediaItem> songs = [];

    // Create an instance of OnAudioQuery for querying songs
    final OnAudioQuery onAudioQuery = OnAudioQuery();

    // Query the device for song information using OnAudioQuery
    final List<SongModel> songModels = await onAudioQuery.querySongs();

    // Convert each SongModel to a MediaItem and add it to the list of songs
    for (final SongModel songModel in songModels) {
      final MediaItem song = await songToMediaItem(songModel);
      songs.add(song);
    }

    // Return the list of songs
    return songs;
  } catch (e) {
    // Handle any errors that occur during the process
    debugPrint('Error fetching songs: $e');
    return []; // Return an empty list in case of error
  }
}
