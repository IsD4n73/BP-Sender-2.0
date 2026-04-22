enum EmailDeliveryChannel {
  smtp,
  outlook,
}

class EmailSendResult {
  final bool isSuccess;
  final EmailDeliveryChannel? channel;
  final String? error;

  const EmailSendResult._({
    required this.isSuccess,
    this.channel,
    this.error,
  });

  factory EmailSendResult.success(EmailDeliveryChannel channel) {
    return EmailSendResult._(isSuccess: true, channel: channel);
  }

  factory EmailSendResult.failure(String error) {
    return EmailSendResult._(isSuccess: false, error: error);
  }
}
