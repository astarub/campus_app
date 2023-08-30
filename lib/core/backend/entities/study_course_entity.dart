class StudyCourse {
  final int pId;
  final String name;

  const StudyCourse({
    required this.pId,
    required this.name,
  });

  const StudyCourse.empty({
    this.pId = 0,
    this.name = '',
  });

  factory StudyCourse.fromJson({
    required Map<String, dynamic> json,
  }) {
    return StudyCourse(
      pId: json['pId'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toInternalJson() {
    return {
      'pId': pId,
      'name': name,
    };
  }
}
