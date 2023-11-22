class StudyCourse {
  final int pId;
  final String name;
  final String faculty;

  const StudyCourse({
    required this.pId,
    required this.name,
    required this.faculty,
  });

  const StudyCourse.empty({
    this.pId = 0,
    this.name = '',
    this.faculty = 'sonstige Einrichtung',
  });

  factory StudyCourse.fromJson({
    required Map<String, dynamic> json,
  }) {
    return StudyCourse(
      pId: json['pId'],
      name: json['name'],
      faculty: json['faculty'],
    );
  }

  Map<String, dynamic> toInternalJson() {
    return {
      'pId': pId,
      'name': name,
      'faculty': faculty,
    };
  }
}
