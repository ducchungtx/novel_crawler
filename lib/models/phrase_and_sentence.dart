import 'package:novel_crawler/models/audio_section.dart';

class Phrase {
  final String title;
  final String audioUrl;
  final List<AudioSection> audioSections;
  final List<String> textSections;

  Phrase({
    required this.title,
    required this.audioUrl,
    required this.audioSections,
    required this.textSections,
  });
}