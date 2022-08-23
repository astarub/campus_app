class Settings {
  final bool useSystemDarkmode;
  final bool useDarkmode;

  Settings({
    this.useSystemDarkmode = true,
    this.useDarkmode = false,
  });

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      useSystemDarkmode: json['useSystemDarkmode'] ?? true,
      useDarkmode: json['useDarkmode'] ?? false,
    );
  }
}
