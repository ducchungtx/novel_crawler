class AudioSection {
  final String content;
  final String url;
  AudioSection({required this.content, required this.url});

  // convert to json
  Map<String, dynamic> toJson() => {
        'content': content,
        'url': url,
      };
}
