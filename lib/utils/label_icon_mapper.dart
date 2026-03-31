import 'package:flutter/material.dart';

/// Maps predefined label names (lowercase) to specific icons.
/// This provides visual identification of common torrent categories
/// in the drawer's Labels section, similar to the ruTorrent web interface.
const Map<String, IconData> _labelIconMap = {
  'video': Icons.movie_outlined,
  'videos': Icons.movie_outlined,
  'movie': Icons.movie_outlined,
  'movies': Icons.movie_outlined,
  'film': Icons.movie_outlined,
  'films': Icons.movie_outlined,
  'audio': Icons.music_note_outlined,
  'music': Icons.music_note_outlined,
  'songs': Icons.music_note_outlined,
  'tv': Icons.tv_outlined,
  'television': Icons.tv_outlined,
  'tv shows': Icons.tv_outlined,
  'series': Icons.tv_outlined,
  'games': Icons.sports_esports_outlined,
  'game': Icons.sports_esports_outlined,
  'gaming': Icons.sports_esports_outlined,
  'books': Icons.menu_book_outlined,
  'book': Icons.menu_book_outlined,
  'ebooks': Icons.menu_book_outlined,
  'ebook': Icons.menu_book_outlined,
  'software': Icons.computer_outlined,
  'apps': Icons.computer_outlined,
  'application': Icons.computer_outlined,
  'applications': Icons.computer_outlined,
  'documents': Icons.description_outlined,
  'document': Icons.description_outlined,
  'docs': Icons.description_outlined,
  'images': Icons.image_outlined,
  'image': Icons.image_outlined,
  'photos': Icons.image_outlined,
  'photo': Icons.image_outlined,
  'pictures': Icons.image_outlined,
  'anime': Icons.animation_outlined,
  'podcast': Icons.podcasts_outlined,
  'podcasts': Icons.podcasts_outlined,
  'sports': Icons.sports_outlined,
  'sport': Icons.sports_outlined,
  'adult': Icons.eighteen_up_rating_outlined,
  'xxx': Icons.eighteen_up_rating_outlined,
  'linux': Icons.computer_outlined,
  'iso': Icons.album_outlined,
};

/// Returns the appropriate icon for a given label name.
/// Falls back to [Icons.label_important_outline] for unrecognized labels.
IconData getLabelIcon(String label) {
  return _labelIconMap[label.toLowerCase().trim()] ??
      Icons.label_important_outline;
}
