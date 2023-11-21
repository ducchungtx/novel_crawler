import 'package:novel_crawler/models/audio_section.dart';

class Conversation {
  final String title;
  final String videoUrl;
  final String audioUrl;

  final List<AudioSection> audioSections;

  Conversation(
    this.audioSections, {
    required this.title,
    required this.videoUrl,
    required this.audioUrl,
  });
}
