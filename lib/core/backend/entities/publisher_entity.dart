class Publisher {
  final int id;
  final String name;
  bool initiallyDisplayed;

  Publisher({
    required this.id,
    required this.name,
    this.initiallyDisplayed = false,
  });

  Publisher.empty({
    this.id = 0,
    this.name = '',
    this.initiallyDisplayed = false,
  });

  factory Publisher.fromJson({
    required Map<String, dynamic> json,
  }) {
    return Publisher(
      id: json['id'],
      name: json['name'],
      initiallyDisplayed: json['initiallyDisplayed'],
    );
  }

  Map<String, dynamic> toInternalJson() {
    return {
      'id': id,
      'name': name,
      'initiallyDisplayed': initiallyDisplayed,
    };
  }
}
