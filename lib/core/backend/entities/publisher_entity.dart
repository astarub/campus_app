class Publisher {
  final int id;
  final String name;
  bool initiallyDisplayed;
  bool hidden;

  Publisher({
    required this.id,
    required this.name,
    this.initiallyDisplayed = false,
    this.hidden = false,
  });

  Publisher.empty({
    this.id = 0,
    this.name = '',
    this.initiallyDisplayed = false,
    this.hidden = false,
  });

  factory Publisher.fromJson({
    required Map<String, dynamic> json,
  }) {
    return Publisher(
      id: json['id'],
      name: json['name'],
      initiallyDisplayed: json['initiallyDisplayed'],
      hidden: json['hidden'],
    );
  }

  Map<String, dynamic> toInternalJson() {
    return {
      'id': id,
      'name': name,
      'initiallyDisplayed': initiallyDisplayed,
      'hidden': hidden,
    };
  }
}
