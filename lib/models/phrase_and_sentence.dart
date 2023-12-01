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

  // Method to create a new instance with a different audioUrl
  Phrase copyWith({String? newAudioUrl}) {
    return Phrase(
      title: title,
      audioUrl: newAudioUrl ?? audioUrl,
      audioSections: audioSections,
      textSections: textSections,
    );
  }

  // convert to json
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'audioUrl': audioUrl,
      'audioSections': audioSections.map((e) => e.toJson()).toList(),
      'textSections': textSections,
    };
  }

  // from json
  factory Phrase.fromJson(Map<String, dynamic> json) {
    return Phrase(
      title: json['title'] as String,
      audioUrl: json['audioUrl'] as String,
      audioSections: (json['audioSections'] as List)
          .map((e) => AudioSection.fromJson(e))
          .toList(),
      textSections:
          (json['textSections'] as List).map((e) => e as String).toList(),
    );
  }
}
