import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:on_audio_query/on_audio_query.dart';

// Asynchronous function to get the artwork for a song
Future<Uri?> getSongArt({
  required int id,
  required ArtworkType type,
  required int quality,
  required int size,
}) async {
  try {
    // Create an instance of OnAudioQuery for querying artwork
    final OnAudioQuery onAudioQuery = OnAudioQuery();

    // Query artwork data for the specified song
    final Uint8List? data = await onAudioQuery.queryArtwork(
      id,
      type,
      quality: quality,
      format: ArtworkFormat.JPEG,
      size: size,
    );

    // Variable to store the artwork's Uri
    Uri? art;

    // Check if artwork data is not null
    if (data != null) {
      // Create a temporary directory to store the artwork file
      final Directory tempDir = Directory.systemTemp;

      // Create a file in the temporary directory with the song's id as the filename
      final File file = File("${tempDir.path}/$id.jpg");

      // Write the artwork data to the file
      await file.writeAsBytes(data);

      // Set the artwork variable to the Uri of the created file
      art = file.uri;
    }

    // Return the artwork's Uri
    return art;
  } catch (e) {
    // Handle any errors that occur during the process
    debugPrint('Error fetching song artwork: $e');
    return null; // Return null in case of error
  }
}
