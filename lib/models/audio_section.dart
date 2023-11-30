class AudioSection {
  final String content;
  final String url;

  AudioSection({required this.content, required this.url});

  // Method to create a new instance with a different URL
  AudioSection copyWith({String? newUrl}) {
    return AudioSection(
      content: content,
      url: newUrl ?? url,
    );
  }

  // convert to json
  Map<String, dynamic> toJson() => {
        'content': content,
        'url': url,
      };

  // from json
  factory AudioSection.fromJson(Map<String, dynamic> json) {
    return AudioSection(
      content: json['content'],
      url: json['url'],
    );
  }
}
