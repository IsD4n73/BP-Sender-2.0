enum OutlookFallbackStatus {
  sent,
  skipped,
  failed,
}

class OutlookFallbackResult {
  final OutlookFallbackStatus status;
  final String message;

  const OutlookFallbackResult({
    required this.status,
    required this.message,
  });

  bool get isSent => status == OutlookFallbackStatus.sent;
}
