import 'dart:convert';

import 'gbk_maps.dart';


gbk_bytesCodec gbk_bytes =  gbk_bytesCodec();

Map<int, String> _gbkCode_to_char = {};
Map<String, int> _char_to_gbkCode = {};


class gbk_bytesCodec extends Encoding {
  @override
  Converter<List<int>, String> get decoder => const gbk_bytesDecoder();

  @override
  Converter<String, List<int>> get encoder => const gbk_bytesEncoder();

  @override
  String get name => 'gbk_bytes';

  gbk_bytesCodec(){
    //initialize gbk code maps
    _char_to_gbkCode = json_char_to_gbk;
    json_gbk_to_char.forEach((sInt, sChar) {
      _gbkCode_to_char[int.parse(sInt, radix : 16)] = sChar;
    });

  }
}

class gbk_bytesEncoder extends Converter<String, List<int>> {
  const gbk_bytesEncoder();

  @override
  List<int> convert(String input) {
    return gbk_bytesEncode(input);
  }
}

List<int> gbk_bytesEncode(String input) {
  var ret = <int>[];
  input.codeUnits.forEach( (charCode) {
    var char = String.fromCharCode(charCode);
    //print(char);
    var gbkCode = _char_to_gbkCode[char];
    //print('$char  = ${gbkCode.toRadixString(16)}');
    if (gbkCode != null ) {
      //split to two bytes
      var a =(gbkCode >> 8) & 0xff;
      var b = gbkCode & 0xff;
      ret.add(a);
      ret.add(b);
      //print(' ${gbkCode.toRadixString(16)}  -- ${a.toRadixString(16)}  ${b.toRadixString(16)}');
    }
    else {
      ret.add(charCode);
    }

  });
  return ret;
}

class gbk_bytesDecoder extends Converter<List<int>, String> {
  const gbk_bytesDecoder();

  @override
  String convert(List<int> input) {
    return gbk_bytesDecode(input);
  }
}

String gbk_bytesDecode(List<int> input) {
  var ret = '';
  var combined = <int>[];
  var id= 0;
  while(id<input.length) {
      var charCode = input[id];
      id ++;
      if (charCode < 0x80 || charCode > 0xff || id == input.length) {
        combined.add(charCode);
      } else {
        charCode = ((charCode)<< 8) + (input[id] & 0xff);
        id ++;
        combined.add(charCode);
      }
  }
  combined.forEach((charCode) {
    var char = _gbkCode_to_char[charCode];
    if (char != null) {
      ret += char;
    } else {
      ret += String.fromCharCode(charCode);
    }
    //print(ret);
  });
  return ret;
}