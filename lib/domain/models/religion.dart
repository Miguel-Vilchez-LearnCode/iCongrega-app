class Religion {
  final int id;
  final String name;
  final String slug;
  final String image;

  Religion({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
  });

  factory Religion.fromJson(Map<String, dynamic> json) {
    return Religion(
      id: json["id"],
      name: json["name"],
      slug: json["slug"] ?? "",
      image: json["image"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'image': image,
    };
  }
}
