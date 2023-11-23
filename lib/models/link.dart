class Link {
  String url;
  String name;

  Link({required this.url, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
    };
  }

  factory Link.fromMap(Map<String, dynamic> map) {
    return Link(
      name: map['name'],
      url: map['url'],
    );
  }

  Map toJson() => {
        'name': name,
        'url': url,
      };
}
