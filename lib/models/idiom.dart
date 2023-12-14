import 'package:novel_crawler/models/audio_section.dart';

class Idiom {
  String sectionName;
  String sectionSubtitle;
  List<AudioSection> children;

  Idiom({
    required this.sectionName,
    required this.sectionSubtitle,
    required this.children,
  });
}
