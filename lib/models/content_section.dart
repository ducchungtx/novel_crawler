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

  // convert to json
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': desc,
      'audioSections': audioSections.map((e) => e.toJson()).toList(),
    };
  }

  // from json
  factory ContentSection.fromJson(Map<String, dynamic> json) {
    return ContentSection(
      title: json['title'],
      desc: json['desc'],
      audioSections: (json['audioSections'] as List)
          .map((e) => AudioSection.fromJson(e)).toList()
    );
  }
}
