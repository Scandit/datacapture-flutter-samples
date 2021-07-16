enum LocationSelectionType { none, radius, rectangular }

extension LocationSelectionTypePrettyPrint on LocationSelectionType {
  String get name => _name();

  String _name() {
    switch (this) {
      case LocationSelectionType.none:
        return 'None';
      case LocationSelectionType.radius:
        return 'Radius';
      case LocationSelectionType.rectangular:
        return 'Rectangular';
      default:
        throw Exception("Missing pretty name for '$this' location sekection type");
    }
  }
}
