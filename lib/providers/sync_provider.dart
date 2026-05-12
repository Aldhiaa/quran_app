import 'package:flutter/foundation.dart';

import '../core/storage/sync_queue_store.dart';
import '../models/sync/sync_queue_item.dart';
import '../services/sync_service.dart';

class SyncProvider with ChangeNotifier {
  final SyncService _service;
  final SyncQueueStore _store;

  bool isSyncing = false;
  String? error;
  Map<String, dynamic> serverStatus = {};
  final List<SyncQueueItem> queue = [];

  SyncProvider({SyncService? service, SyncQueueStore? store})
      : _service = service ?? SyncService(),
        _store = store ?? const SyncQueueStore();

  int get pendingCount => queue.where((item) => item.status == 'pending').length;
  bool get hasPending => pendingCount > 0;

  Future<void> hydrate() async {
    queue
      ..clear()
      ..addAll(await _store.load());
    notifyListeners();
  }

  Future<void> enqueue(SyncQueueItem item) async {
    queue.add(item);
    await _store.save(queue);
    notifyListeners();
  }

  Future<void> loadStatus() async {
    try {
      serverStatus = await _service.status();
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  Future<void> pushPending() async {
    if (pendingCount == 0) return;
    isSyncing = true;
    error = null;
    notifyListeners();

    try {
      await _service.push(queue.where((item) => item.status == 'pending').toList());
      for (var i = 0; i < queue.length; i++) {
        if (queue[i].status == 'pending') {
          queue[i] = queue[i].copyWith(status: 'synced');
        }
      }
      await _store.save(queue);
    } catch (e) {
      error = e.toString();
      for (var i = 0; i < queue.length; i++) {
        if (queue[i].status == 'pending') {
          queue[i] = queue[i].copyWith(
            status: 'failed',
            retryCount: queue[i].retryCount + 1,
            lastError: error,
          );
        }
      }
      await _store.save(queue);
    } finally {
      isSyncing = false;
      notifyListeners();
    }
  }
}
