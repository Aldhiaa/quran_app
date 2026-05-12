class SyncEndpoints {
  const SyncEndpoints._();

  static const pull = '/sync/pull';
  static const push = '/sync/push';
  static const status = '/sync/status';

  static String resolveConflict(int id) => '/sync/conflicts/$id/resolve';
}

