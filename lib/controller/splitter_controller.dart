import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'package:buste_paga_sender/model/correction_ocr.dart';
import 'package:buste_paga_sender/page/file_splitter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:http/http.dart' as http;

// create inviate folder
Future<void> createSplittedDir(String dir) async {
  final path = Directory("$dir/splitted");
  if ((await path.exists())) {
  } else {
    path.create();
  }
}

// split file to multiple
Future<void> splitFile(File file) async {
  namesController.value.text = "\n======== INIZIO ========\n\n";
  var bytes = await file.readAsBytes();

  namesController.value.text +=
      "\n[INFO] ==> Dimensione del documento: ${getFileSizeString(bytes: bytes.lengthInBytes, decimals: 2)}";

  final PdfDocument document = PdfDocument(inputBytes: bytes);

  namesController.value.text +=
      "\n[INFO] ==> Pagine del documento: ${document.pages.count}";
  debugPrint("TOT PAG: ${document.pages.count}");

  PdfTextExtractor extractor = PdfTextExtractor(document);

  var find = await compute((ext) {
    return ext
        .extractTextLines()
        .where((element) => element.text.contains("CERTIFICAZIONE DI CUI"))
        .toList();
  }, extractor);

  /*var find = extractor
      .extractTextLines()
      .where((element) => element.text.contains("CERTIFICAZIONE DI CUI"))
      .toList();*/

  int fileToGenerate = find.length;
  if (fileToGenerate < 1) {
    throw FormatException("fileToGenerate è:  $fileToGenerate");
  }

  int doneFile = 0;
  debugPrint("FILE GEN: $fileToGenerate");
  namesController.value.text +=
      "\n[INFO] ==> File da generare: $fileToGenerate\n\n";

  PdfDocument splittedPdf = PdfDocument();
  splittedPdf.pageSettings.margins.all = 0;

  for (int i = 1; i <= document.pages.count; i++) {
    PdfPage page = document.pages[i - 1];

    splittedPdf.pages.add().graphics.drawPdfTemplate(
          page.createTemplate(),
          const Offset(0, 0),
        );

    int index = doneFile + 1;
    int pageOfFinish = 0;

    if (doneFile + 1 == find.length) {
      pageOfFinish = document.pages.count;
    } else {
      pageOfFinish = find[index].pageIndex;
    }

    if (i == pageOfFinish) {
      var tmpByte = await splittedPdf.save();

      File tmpFile = File(
          "${file.parent.path}/splitted/$fileToGenerate - Certificazione Unica.pdf");
      if (!tmpFile.existsSync()) {
        await tmpFile.create(recursive: true);
      }
      await tmpFile.writeAsBytes(tmpByte);

      /* IMAGE TO EXTRACT */
      var rasterPdf = await Printing.raster(
        await tmpFile.readAsBytes(),
        pages: [0],
        dpi: 400,
      ).first;
      var image = await rasterPdf.toPng();

      var response = await http.post(
        Uri.parse('http://127.0.0.1:55004/ocr/cu'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'img': base64Encode(image)}),
      );

      if (response.statusCode == 200) {
        String nameFound = response.body.trim();
        CorrectionOcr.correction.any((e) {
          if (nameFound.contains(e.ocr.toUpperCase())) {
            debugPrint("Correzione effettuata ${e.ocr} -> ${e.name}");
            nameFound = nameFound.replaceAll(
              e.ocr.toUpperCase(),
              e.name.toUpperCase(),
            );
          }
          return false;
        });
        debugPrint("NOME TROVATO: $nameFound");
        await renameFile(tmpFile, fileToGenerate.toString(), nameFound);

        namesController.value.text +=
            "\n[INFO] ==> File generato correttamente con nome: $nameFound";
      }

      /* ============= */

      splittedPdf = PdfDocument();
      splittedPdf.pageSettings.margins.all = 0;
      fileToGenerate--;
      doneFile++;
    }
  }
  document.dispose();
  namesController.value.text += "\n\n======== FINE ========\n";
}

String getFileSizeString({required int bytes, int decimals = 2}) {
  const suffixes = [" B", " KB", " MB", " GB", " TB"];
  if (bytes == 0) return '0${suffixes[0]}';
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
}

Future<void> renameFile(File baseFile, String replace, String nome) async {
  if (File(baseFile.path.replaceAll(replace, nome)).existsSync()) {
    int fileGiaEsistenti = 0;
    while (true) {
      File nextFilePath = File(
          "${baseFile.parent.path}/$nome - Certificazione Unica ${fileGiaEsistenti + 1}.pdf");

      if (!await nextFilePath.exists()) {
        await baseFile.rename(nextFilePath.path);
        return;
      } else {
        fileGiaEsistenti++;
      }
    }
  } else {
    await baseFile.rename(
      baseFile.path.replaceAll(replace, nome),
    );
  }
}
