/*
  file name: create_map
  Function: preprocess, that create gbk map from standard data
  The map data will be saved by json format
 */

//import 'dart:html';
import 'dart:convert';

import 'dart:io';

import 'package:html/dom.dart' as dom;

import 'body_element.dart';

Map<String, int>? gbkMap; // = new Map<String, int>();  //key is single length String

void main() async {
  //key is single length String (character)
  //value is codeUnit of GBK

  //load html gbk data
  var firstCode = <String>[] ; // = new List<String>();
  await pageBody().then((dom.Element? bodySource) {
    var lines = <String>[];
    bodySource!.querySelectorAll('p').forEach((e) => lines.add(e.outerHtml));
    for (var l in lines){
      if (l.indexOf('０ １ ２ ３ ４ ５ ６ ７ ８ ９ Ａ Ｂ Ｃ Ｄ Ｅ Ｆ') > 0){
        l = l.replaceAll('０ １ ２ ３ ４ ５ ６ ７ ８ ９ Ａ Ｂ Ｃ Ｄ Ｅ Ｆ', '');
        l = l.replaceAll('&nbsp;', '');
        firstCode.add(l);
        print(l);
        //print(l.indexOf('<p>AA <br>Ａ'));
        if (l.contains('<p>A9 <br>４')) {
          print('---------break point----------------');
          break;
        } //last item
      }
    }
  });
  print(firstCode.length);
  firstCode.forEach((s) => lineReader(s));

  // check
  gbkMap!.forEach((String char, int gbkCode){
    print('$char  gbkCode=${gbkCode.toRadixString(16)}  unitCode:${char.codeUnitAt(0).toRadixString(16)}');
  });

  var sortChar = gbkMap!.keys.toList()..sort();
  var sameKeys = <String>[];
  var last = '\u0200';
  sortChar.forEach((s) {
    if (s == last) sameKeys.add(s);
    last = s;
  });
  print(sameKeys.length);

  var sortUnit = gbkMap!.values.toList()..sort();
  var sameUnits = <int>[];
  var lst = 9999;
  sortUnit.forEach((i) {
    if (i == lst) {
      sameUnits.add(i);
      print('--- find! ${lst.toRadixString(16)}');
    }
    lst = i;
  });
  print(sameUnits.length);
  var look = int.parse('FE66', radix: 16);
  var idn = sameUnits.where((i) => look==i);
  print(idn);


  //outputs
  var json_char_to_gbk =  jsonEncode(gbkMap);
  final file1 = 'json_char_to_gbk.data';
  await File(file1).writeAsString(json_char_to_gbk);
  print(json_char_to_gbk);
  print(gbkMap!.length); 

  var reversed_gbkMap = <String, String>{};
  /*
  gbkMap.forEach((s,i) {
    reversed_gbkMap[i]=s;
  });*/

  gbkMap!.forEach((s,intS) {
    reversed_gbkMap[intS.toRadixString(16)]=s[0];
  });

  var json_gbk_to_char =  jsonEncode(reversed_gbkMap);
  final file2 = 'json_gbk_to_char.data';
  await File(file2).writeAsString(json_gbk_to_char);

  print(reversed_gbkMap);
  print(reversed_gbkMap.length);
  //String json_gbk_to_char =  jsonEncode(reversed_gbkMap);
  print(json_gbk_to_char);


}

void lineReader(String line) {
  String l, RD, TH;
  var lastID = <String>['0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'];
  var firstByte =  line.substring(3,5);
  //print(firstByte);
  print(line);
  l = line.substring(10,line.length-4);
  print(l);
  var third = l.split('<br>');
  //print(third);
  third.forEach((String group) {
    print(group);
    var charList = group.split(' ');
    print(charList);
    RD = ascii09AF(charList[0]);
    for(var i = 1; i<charList.length; i++) {
      TH = lastID[i-1];
      var hex = firstByte + RD + TH;
      //print('${charList[i]} : $hex');
      /*
      Map<String, int> mNewword = new Map<String, int>();
      mNewword[charList[i]] = int.parse(hex, radix: 16);
      gbkMap.addAll(mNewword);*/
      //gbkMap[charList[i]] = int.parse(hex, radix: 16); //unitCode
      gbkMap!.putIfAbsent(charList[i], ()=> int.parse(hex, radix: 16));
      print('"${charList[i]}" $hex = ${hex.codeUnitAt(0)} ${hex.codeUnitAt(1)} ${hex.codeUnitAt(2)} ${hex.codeUnitAt(3)} ');

    }
  });
}

String ascii09AF(String gbkChar) {
  switch (gbkChar) {
    case 'Ａ': return 'A';
    case 'Ｂ': return 'B';
    case 'Ｃ': return 'C';
    case 'Ｄ': return 'D';
    case 'Ｅ': return 'E';
    case 'Ｆ': return 'F';
    case '０': return '0';
    case '１': return '1';
    case '２': return '2';
    case '３': return '3';
    case '４': return '4';
    case '５': return '5';
    case '６': return '6';
    case '７': return '7';
    case '８': return '8';
    case '９': return '9';

    default:
    // do something else
  }
  return gbkChar;
}
