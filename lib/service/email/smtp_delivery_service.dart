import 'dart:async';
import 'dart:io';

import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';

import '../../common/smtp_configuration.dart';
import '../../model/account_model.dart';
import '../../model/email/email_send_result.dart';

class SmtpDeliveryService {
  static const Duration _timeout = Duration(seconds: 25);

  Future<EmailSendResult> send({
    required AccountModel account,
    required String recipient,
    required String subject,
    required String htmlBody,
    required String host,
    required int port,
    String? attachmentPath,
  }) async {
    final servers = _buildServers(account, host: host, port: port);
    final failures = <String>[];

    for (final server in servers) {
      try {
        final message = mailer.Message()
          ..from = mailer.Address(account.email!)
          ..recipients.add(recipient)
          ..subject = subject
          ..html = htmlBody;

        if (attachmentPath != null &&
            attachmentPath.isNotEmpty &&
            AppConfig.sendFile &&
            await File(attachmentPath).exists()) {
          message.attachments = [
            mailer.FileAttachment(File(attachmentPath))
              ..location = mailer.Location.attachment,
          ];
        }

        await mailer.send(message, server).timeout(_timeout);
        return EmailSendResult.success(EmailDeliveryChannel.smtp);
      } on TimeoutException {
        failures.add('timeout su ${server.host}:${server.port}');
      } catch (e) {
        failures.add('${server.host}:${server.port} -> $e');
      }
    }

    return EmailSendResult.failure(failures.join(' | '));
  }

  List<SmtpServer> _buildServers(AccountModel account, {required String host, required int port}) {

    final base = SmtpServer(
      host,
      username: account.user,
      password: account.password,
      port: port,
      ssl: port == 465,
      allowInsecure: false,
      ignoreBadCertificate: false,
    );

    final fallbackStartTls = SmtpServer(
      host,
      username: account.user,
      password: account.password,
      port: port,
      ssl: false,
      allowInsecure: false,
      ignoreBadCertificate: false,
    );

    final fallbackInsecure = SmtpServer(
      host,
      username: account.user,
      password: account.password,
      port: port,
      ssl: false,
      allowInsecure: true,
      ignoreBadCertificate: true,
    );

    if (port == 465) {
      return [base, fallbackStartTls, fallbackInsecure];
    }

    return [base, fallbackInsecure];
  }
}
