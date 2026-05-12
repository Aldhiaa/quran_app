class ResponseUtils {
  const ResponseUtils._();

  static Map<String, dynamic> asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  static dynamic data(dynamic value) {
    if (value is Map && value.containsKey('data')) return value['data'];
    return value;
  }

  static List<Map<String, dynamic>> list(dynamic value) {
    final raw = data(value);
    if (raw is List) {
      return raw
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList(growable: false);
    }
    if (raw is Map && raw['data'] is List) {
      return (raw['data'] as List)
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList(growable: false);
    }
    return const [];
  }

  static Map<String, dynamic> dataMap(dynamic value) {
    return asMap(data(value));
  }
}

