class Kategorie {
  Kategorie({
    this.id,
    this.name,
    this.snackbar,
    this.farbe,
    this.icon,
  });

  final int id;
  final String name;
  final String snackbar;
  final int farbe;
  final String icon;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'snackbar': snackbar,
      'farbe': farbe,
      'icon': icon,
    };
  }
}
