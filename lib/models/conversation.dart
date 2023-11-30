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

  // Method to create a new instance with a different audioUrl
  Conversation copyWith({String? newAudioUrl}) {
    return Conversation(
      title: title,
      videoUrl: videoUrl,
      audioUrl: newAudioUrl ?? audioUrl,
      audioSections: audioSections,
    );
  }


  // convert to json
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'audioSections': audioSections.map((e) => e.toJson()).toList(),
    };
  }

  // from json
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      title: json['title'],
      videoUrl: json['videoUrl'],
      audioUrl: json['audioUrl'],
      audioSections: (json['audioSections'] as List)
          .map((e) => AudioSection.fromJson(e))
          .toList(),
    
    );
  }
}
