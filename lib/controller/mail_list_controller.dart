import '../common/urls.dart';
import '../model/maillist_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

//get the mail list as list
Future<List<MailListModel>> getMailList() async {
  List<MailListModel> list = [];

  final response = await http.get(Uri.parse(AppUrls.csvFile));

  if (response.statusCode == 200) {
    var listEmail = response.body.replaceAll("", "").split('\n');

    for (var persona in listEmail) {
      var nameEmail = persona.split(";");

      if (nameEmail[0].isNotEmpty && nameEmail[1].isNotEmpty) {
        MailListModel m = MailListModel(
          nome: nameEmail[0],
          email: nameEmail[1],
        );
        list.add(m);
      }
    }
  }
  return list;
}

//get the mail list as map
Future<Map<String, String>> getMailListAsMap() async {
  final Map<String, String> list = {};

  final response = await http.get(Uri.parse(AppUrls.csvFile));

  if (response.statusCode == 200) {
    var listEmail = response.body.replaceAll("", "").split('\n');

    for (var persona in listEmail) {
      try {
        var tmp = persona.split(";");
        list[tmp[0].toUpperCase()] = tmp[1].trim();
      } on RangeError {
        debugPrint("out of range");
      }
    }
  }
  return list;
}
