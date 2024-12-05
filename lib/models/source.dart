class Source {
  final String? id;
  final String name;

  const Source({required this.id, required this.name});

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json['id'] ?? '',
        name: json['name'],
      );

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
