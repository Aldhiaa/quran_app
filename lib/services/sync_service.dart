import 'package:http/http.dart' as http;

import '../core/api/api_client.dart';
import '../core/api/endpoints/sync_endpoints.dart';
import '../core/utils/response_utils.dart';
import '../models/sync/sync_queue_item.dart';

class SyncService {
  final ApiClient _apiClient;

  SyncService({http.Client? httpClient, ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient(httpClient: httpClient);

  Future<Map<String, dynamic>> pull({DateTime? since}) async {
    return ResponseUtils.dataMap(
      await _apiClient.get(
        SyncEndpoints.pull,
        queryParameters: {
          if (since != null) 'since': since.toIso8601String(),
        },
      ),
    );
  }

  Future<Map<String, dynamic>> push(List<SyncQueueItem> items) async {
    return ResponseUtils.dataMap(
      await _apiClient.post(
        SyncEndpoints.push,
        body: {'payload': items.map((item) => item.toJson()).toList()},
      ),
    );
  }

  Future<Map<String, dynamic>> status() async {
    return ResponseUtils.dataMap(await _apiClient.get(SyncEndpoints.status));
  }

  Future<Map<String, dynamic>> resolveConflict({
    required int conflictId,
    required String resolution,
    String? notes,
  }) async {
    return ResponseUtils.dataMap(
      await _apiClient.post(
        SyncEndpoints.resolveConflict(conflictId),
        body: {'resolution': resolution, if (notes != null) 'notes': notes},
      ),
    );
  }
}

