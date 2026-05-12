class SyncQueueItem {
  final String localId;
  final String endpoint;
  final String method;
  final Map<String, dynamic> payload;
  final String status;
  final int retryCount;
  final String idempotencyKey;
  final DateTime createdAt;
  final String? lastError;

  const SyncQueueItem({
    required this.localId,
    required this.endpoint,
    required this.method,
    required this.payload,
    required this.status,
    required this.retryCount,
    required this.idempotencyKey,
    required this.createdAt,
    this.lastError,
  });

  factory SyncQueueItem.pending({
    required String localId,
    required String endpoint,
    required String method,
    required Map<String, dynamic> payload,
    required String idempotencyKey,
  }) {
    return SyncQueueItem(
      localId: localId,
      endpoint: endpoint,
      method: method,
      payload: payload,
      status: 'pending',
      retryCount: 0,
      idempotencyKey: idempotencyKey,
      createdAt: DateTime.now(),
    );
  }

  factory SyncQueueItem.fromJson(Map<String, dynamic> json) {
    return SyncQueueItem(
      localId: '${json['local_id'] ?? json['localId']}',
      endpoint: '${json['endpoint']}',
      method: '${json['method']}',
      payload: Map<String, dynamic>.from(json['payload'] as Map? ?? const {}),
      status: '${json['status'] ?? 'pending'}',
      retryCount: json['retry_count'] is int ? json['retry_count'] as int : int.tryParse('${json['retry_count'] ?? 0}') ?? 0,
      idempotencyKey: '${json['idempotency_key'] ?? json['idempotencyKey']}',
      createdAt: DateTime.tryParse('${json['created_at'] ?? json['createdAt']}') ?? DateTime.now(),
      lastError: json['last_error']?.toString() ?? json['lastError']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'local_id': localId,
      'endpoint': endpoint,
      'method': method,
      'payload': payload,
      'status': status,
      'retry_count': retryCount,
      'idempotency_key': idempotencyKey,
      'created_at': createdAt.toIso8601String(),
      'last_error': lastError,
    };
  }

  SyncQueueItem copyWith({
    String? status,
    int? retryCount,
    String? lastError,
  }) {
    return SyncQueueItem(
      localId: localId,
      endpoint: endpoint,
      method: method,
      payload: payload,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      idempotencyKey: idempotencyKey,
      createdAt: createdAt,
      lastError: lastError ?? this.lastError,
    );
  }
}

