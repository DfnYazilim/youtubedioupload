import 'dart:math';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class UploadProvider with ChangeNotifier{
  Dio dio = Dio();
  int? _sent = 0;
  int? _total = 0;

  int? get sent => _sent;

  int? get total => _total;

  num? get percentage => (_sent!/_total! * 100);
  String? get percentageTxt => (_sent!/_total! * 100).toStringAsFixed(2);

   String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    if (bytes == 0) return '0${suffixes[0]}';
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  Future<void> uploadFn() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    (result?.files ?? []).forEach((element) {
      print(element.name);
      print(element.path);
    });
    if ((result?.files ?? []).isEmpty) return;
    var ff = await MultipartFile.fromFile(result!.files.first.path!,
        filename: result!.files.first.name!);
    var formData = await FormData.fromMap({'photo': ff});
    final response = await dio.post(
      'http://localhost:5560/upload',
      data: formData,
      onSendProgress: (int sent, int total) {
        _sent = sent;
        _total = total;
        print('$_sent $_total');
        notifyListeners();
      },
    );
  }
}