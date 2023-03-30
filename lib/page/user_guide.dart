import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../common/urls.dart';

class UserGuidePage extends StatefulWidget {
  const UserGuidePage({Key? key}) : super(key: key);

  @override
  State<UserGuidePage> createState() => _UserGuidePageState();
}

class _UserGuidePageState extends State<UserGuidePage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SfPdfViewer.network(AppUrls.pdfUserGuide),
    );
  }
}
