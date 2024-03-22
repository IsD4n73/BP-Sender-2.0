import 'package:flutter/material.dart';

class CorrectionOcr {
  CorrectionOcr();

  static List<Correction> correction = [];

  CorrectionOcr.fromJson(Map<String, dynamic> json) {
    correction = json["correction"] == null
        ? []
        : List<Correction>.from(
            json["correction"]!.map(
              (x) => Correction.fromJson(x),
            ),
          );
    debugPrint("Caricate ${correction.length} correzioni");
  }

  @override
  String toString() {
    return "$correction, ";
  }
}

class Correction {
  Correction({
    required this.name,
    required this.ocr,
  });

  final String name;
  final String ocr;

  factory Correction.fromJson(Map<String, dynamic> json) {
    return Correction(
      name: json["name"] ?? "",
      ocr: json["ocr"] ?? "",
    );
  }

  @override
  String toString() {
    return "$name, $ocr, ";
  }
}
