import 'package:novel_crawler/models/audio_section.dart';

class Expression {
  final String title;
  final String audioUrl;
  final List<AudioSection> audioSections;

  Expression({
    required this.title,
    required this.audioUrl,
    required this.audioSections,
  });

  // convert to json
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'audioUrl': audioUrl,
      'audioSections': audioSections.map((e) => e.toJson()).toList(),
    };
  }
}
