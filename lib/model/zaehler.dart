class Zaehler {
  Zaehler({
    this.id,
    this.zahl,
    this.zeitstempel,
    this.kategorie,
  });

  final int id;
  final int zahl;
  final DateTime zeitstempel;
  final int kategorie;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'zahl': zahl,
      'zeitstempel': zeitstempel.toIso8601String(),
      'kategorie': kategorie,
    };
  }
}
