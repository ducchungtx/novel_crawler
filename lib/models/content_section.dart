import 'package:novel_crawler/models/audio_section.dart';

class ContentSection {
  final String title;
  final String desc;
  final List<AudioSection> audioSections;

  ContentSection({
    required this.title,
    required this.desc,
    required this.audioSections,
  });
}
