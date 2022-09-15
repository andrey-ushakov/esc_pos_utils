import 'dart:convert';
import 'dart:typed_data';

import 'package:gbk_codec/gbk_codec.dart';

class TextWithType {
  TextWithType.fromText({
    required this.text,
    this.isCjk = false,
  }) {
    if (text!.length == 0) {
      throw Exception('text should be passed');
    }
    encodedBytes = _encodeText(text!, isCjk: isCjk);
  }

  TextWithType.fromEncoded({
    required this.encodedBytes,
    this.isCjk = false,
  }) {
    if (encodedBytes.length == 0) {
      throw Exception('encodedBytes should be passed');
    }
  }

  String? text;
  bool isCjk;
  late Uint8List encodedBytes;

  Uint8List _encodeText(String text, {bool isCjk = false}) {
    // replace some non-ascii characters
    text = text
        .replaceAll("’", "'")
        .replaceAll("´", "'")
        .replaceAll("»", '"')
        .replaceAll(" ", ' ')
        .replaceAll("•", '.');
    if (!isCjk) {
      return latin1.encode(text);
    } else {
      return Uint8List.fromList(gbk_bytes.encode(text));
    }
  }
}
