import 'package:novel_crawler/models/content_section.dart';

class PhrasalVerb {
  final String title;
  final List<ContentSection> contents;

  PhrasalVerb({
    required this.title,
    required this.contents,
  });

  // convert to json
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'contents': contents.map((e) => e.toJson()).toList(),
    };
  }

  // from json
  factory PhrasalVerb.fromJson(Map<String, dynamic> json) {
    return PhrasalVerb(
      title: json['title'],
      contents: json['contents']
          .map<ContentSection>((e) => ContentSection.fromJson(e))
          .toList(),
      
    );
  }
}
