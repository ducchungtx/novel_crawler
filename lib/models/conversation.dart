import 'package:novel_crawler/models/audio_section.dart';

class Conversation {
  final String title;
  final String videoUrl;
  final String audioUrl;
  final List<AudioSection> audioSections;

  Conversation({
    required this.title,
    required this.videoUrl,
    required this.audioUrl,
    required this.audioSections,
  });

  // convert to json
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'audioSections': audioSections.map((e) => e.toJson()).toList(),
    };
  }
}
