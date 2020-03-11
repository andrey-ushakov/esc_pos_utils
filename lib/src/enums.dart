/*
 * esc_pos_utils
 * Created by Andrey U.
 * 
 * Copyright (c) 2019-2020. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

enum PosTextAlign { left, center, right }
enum PosCutMode { full, partial }
enum PosFontType { fontA, fontB }

class PosTextSize {
  const PosTextSize._internal(this.value);
  final int value;
  static const size1 = PosTextSize._internal(1);
  static const size2 = PosTextSize._internal(2);
  static const size3 = PosTextSize._internal(3);
  static const size4 = PosTextSize._internal(4);
  static const size5 = PosTextSize._internal(5);
  static const size6 = PosTextSize._internal(6);
  static const size7 = PosTextSize._internal(7);
  static const size8 = PosTextSize._internal(8);

  static int decSize(PosTextSize height, PosTextSize width) =>
      16 * (width.value - 1) + (height.value - 1);
}

class PaperSize {
  const PaperSize._internal(this.value);
  final int value;
  static const mm58 = PaperSize._internal(1);
  static const mm80 = PaperSize._internal(2);

  int get width => value == PaperSize.mm58.value ? 350 : 512;
}

class PosBeepDuration {
  const PosBeepDuration._internal(this.value);
  final int value;
  static const beep50ms = PosBeepDuration._internal(1);
  static const beep100ms = PosBeepDuration._internal(2);
  static const beep150ms = PosBeepDuration._internal(3);
  static const beep200ms = PosBeepDuration._internal(4);
  static const beep250ms = PosBeepDuration._internal(5);
  static const beep300ms = PosBeepDuration._internal(6);
  static const beep350ms = PosBeepDuration._internal(7);
  static const beep400ms = PosBeepDuration._internal(8);
  static const beep450ms = PosBeepDuration._internal(9);
}

class PosCodeTable {
  const PosCodeTable(this.value);
  final int value;

  /// PC437 - U.S.A., Standard Europe
  static const pc437 = PosCodeTable(0);

  /// Katakana
  static const katakana = PosCodeTable(1);

  /// PC850 Multilingual
  static const pc850 = PosCodeTable(2);

  /// PC860 - Portuguese
  static const pc860 = PosCodeTable(3);

  /// PC863 - Canadian-French
  static const pc863 = PosCodeTable(4);

  /// PC865 - Nordic
  static const pc865 = PosCodeTable(5);

  /// Western Europe
  static const westEur = PosCodeTable(6);

  /// Greek
  static const greek = PosCodeTable(7);

  /// PC737 - Greek
  static const pc737 = PosCodeTable(64);

  /// PC851 - Greek
  static const pc851 = PosCodeTable(65);

  /// PC869 - Greek
  static const pc869 = PosCodeTable(66);

  /// PC928 - Greek
  static const pc928 = PosCodeTable(67);

  /// PC866 - Russian
  static const pc866_1 = PosCodeTable(59);

  /// PC866 - Cyrillic #2
  static const pc866_2 = PosCodeTable(17);

  /// PC852 - Latin2
  static const pc852 = PosCodeTable(18);

  /// WPC1251 - Cyrillic
  static const wpc1251 = PosCodeTable(73);

  /// WPC1252 - Latin1
  static const wpc1252 = PosCodeTable(71);

  /// Space page
  static const spacePage = PosCodeTable(255);
}
