import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../models/sync/sync_queue_item.dart';

class SyncQueueStore {
  static const _key = 'sync_queue_items';
  final FlutterSecureStorage _storage;

  const SyncQueueStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<List<SyncQueueItem>> load() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.isEmpty) return const [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map>()
        .map((item) => SyncQueueItem.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  Future<void> save(List<SyncQueueItem> items) {
    return _storage.write(
      key: _key,
      value: jsonEncode(items.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> clear() => _storage.delete(key: _key);
}

