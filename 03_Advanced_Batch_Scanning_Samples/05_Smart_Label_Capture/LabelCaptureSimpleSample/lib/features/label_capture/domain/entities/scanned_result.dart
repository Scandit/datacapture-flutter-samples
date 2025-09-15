/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

class ScannedResult {
  final Map<String, String> data;

  const ScannedResult({required this.data});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScannedResult && runtimeType == other.runtimeType && _mapEquals(data, other.data);

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() {
    return data.entries.map((entry) => '${entry.key}: ${entry.value}').join('\n');
  }

  bool _mapEquals(Map<String, String> a, Map<String, String> b) {
    if (a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }
}
