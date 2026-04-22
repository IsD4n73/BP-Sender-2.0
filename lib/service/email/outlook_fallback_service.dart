import 'dart:io';

import '../../model/email/outlook_fallback_result.dart';

class OutlookFallbackService {
  Future<OutlookFallbackResult> sendViaOutlook({
    required String recipient,
    required String subject,
    required String htmlBody,
    String? attachmentPath,
  }) async {
    if (!Platform.isWindows) {
      return const OutlookFallbackResult(
        status: OutlookFallbackStatus.skipped,
        message: 'Fallback Outlook disponibile solo su Windows.',
      );
    }

    final escapedRecipient = _escapePs(recipient);
    final escapedSubject = _escapePs(subject);
    final escapedBody = _escapePs(htmlBody);

    String escapedAttachment = "''";
    if (attachmentPath != null && attachmentPath.isNotEmpty) {
      escapedAttachment = "'${_escapePs(attachmentPath)}'";
    }

    final script = r'''
try {
  $outlook = New-Object -ComObject Outlook.Application
  if ($null -eq $outlook) {
    Write-Output 'Outlook non disponibile.'
    exit 2
  }

  $mail = $outlook.CreateItem(0)
  $mail.To = '__RECIPIENT__'
  $mail.Subject = '__SUBJECT__'
  $mail.HTMLBody = '__BODY__'
  $attachment = __ATTACHMENT__

  if ($attachment -ne '' -and (Test-Path -LiteralPath $attachment)) {
    $mail.Attachments.Add($attachment) | Out-Null
  }

  $mail.Send()
  Write-Output 'Mail inviata via Outlook COM.'
  exit 0
} catch {
  Write-Output $_.Exception.Message
  exit 1
}
'''
        .replaceAll('__RECIPIENT__', escapedRecipient)
        .replaceAll('__SUBJECT__', escapedSubject)
        .replaceAll('__BODY__', escapedBody)
        .replaceAll('__ATTACHMENT__', escapedAttachment);

    final result = await Process.run(
      'powershell',
      [
        '-NoProfile',
        '-NonInteractive',
        '-WindowStyle',
        'Hidden',
        '-Command',
        script,
      ],
    );

    final output = '${result.stdout}'.trim();
    final error = '${result.stderr}'.trim();

    if (result.exitCode == 0) {
      return OutlookFallbackResult(
        status: OutlookFallbackStatus.sent,
        message: output.isNotEmpty ? output : 'Invio Outlook completato.',
      );
    }

    if (result.exitCode == 2) {
      return OutlookFallbackResult(
        status: OutlookFallbackStatus.skipped,
        message: output.isNotEmpty
            ? output
            : 'Outlook non installato o non accessibile via COM.',
      );
    }

    return OutlookFallbackResult(
      status: OutlookFallbackStatus.failed,
      message: [output, error]
          .where((element) => element.isNotEmpty)
          .join(' | '),
    );
  }

  String _escapePs(String input) {
    return input.replaceAll("'", "''");
  }
}
