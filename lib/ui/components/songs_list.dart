import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import 'package:dum/services/song_handler.dart';
import 'package:dum/ui/components/player_deck.dart';
import 'package:dum/ui/components/song_item.dart';
import 'package:dum/utils/formatted_title.dart';

// SongsList class to display a list of songs
class SongsList extends StatelessWidget {
  final List<MediaItem> songs;
  final SongHandler songHandler;
  final AutoScrollController autoScrollController;

  // Constructor for the SongsList class
  const SongsList({
    super.key,
    required this.songs,
    required this.songHandler,
    required this.autoScrollController,
  });

  @override
  Widget build(BuildContext context) {
    // Display a message if there are no songs
    return songs.isEmpty
        ? const Center(
            child: Text("You Have No Taste!!!"),
          )
        : ListView.builder(
            // Build a scrollable list of songs
            controller: autoScrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: songs.length,
            itemBuilder: (context, index) {
              MediaItem song = songs[index];

              // Build the SongItem based on the playback state
              return StreamBuilder<MediaItem?>(
                stream: songHandler.mediaItem.stream,
                builder: (context, snapshot) {
                  MediaItem? playingSong = snapshot.data;

                  // Check if the current item is the last one
                  return index == (songs.length - 1)
                      ? _buildLastSongItem(song, playingSong)
                      : AutoScrollTag(
                          // Utilize AutoScrollTag for automatic scrolling
                          key: ValueKey(index),
                          controller: autoScrollController,
                          index: index,
                          child: _buildRegularSongItem(song, playingSong),
                        );
                },
              );
            },
          );
  }

  // Build the last song item with a PlayerDeck for controls
  Widget _buildLastSongItem(MediaItem song, MediaItem? playingSong) {
    return Column(
      children: [
        // Display the last song item
        SongItem(
          id: int.parse(song.displayDescription!),
          isPlaying: song == playingSong,
          title: formattedTitle(song.title),
          artist: song.artist,
          onSongTap: () async {
            await songHandler.skipToQueueItem(songs.length - 1);
          },
          art: song.artUri,
        ),
        // Display the player deck for controls
        PlayerDeck(
          songHandler: songHandler,
          isLast: true,
          onTap: () {},
        ),
      ],
    );
  }

  // Build a regular song item
  Widget _buildRegularSongItem(MediaItem song, MediaItem? playingSong) {
    return SongItem(
      id: int.parse(song.displayDescription!),
      isPlaying: song == playingSong,
      title: formattedTitle(song.title),
      artist: song.artist,
      onSongTap: () async {
        await songHandler.skipToQueueItem(songs.indexOf(song));
      },
      art: song.artUri,
    );
  }
}
