import 'dart:io';

import 'package:innosetup/innosetup.dart';
import 'package:version/version.dart';

void main() {
  InnoSetup(
    name: const InnoSetupName(
      'Buste Paga 2.0 Installer',
    ),
    app: InnoSetupApp(
      name: 'Buste Paga 2.0',
      version: Version.parse('2.6.0'),
      publisher: '3EM',
      urls: InnoSetupAppUrls(
        homeUrl: Uri.parse('https://3em.it/'),
        publisherUrl: Uri.parse('https://3em.it/'),
      ),
    ),
    files: InnoSetupFiles(
      executable:
          File('build/windows/x64/runner/Release/buste_paga_sender.exe'),
      location: Directory('build/windows/x64/runner'),
    ),
    location: InnoSetupInstallerDirectory(
      Directory('build/windows'),
    ),
    icon: InnoSetupIcon(
      File('assets/resource/logo.ico'),
    ),
    runAfterInstall: false,
    languages: [
      InnoSetupLanguages().italian,
    ],
  ).make();
}
