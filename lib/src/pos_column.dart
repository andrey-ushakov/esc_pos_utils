/*
 * esc_pos_utils
 * Created by Andrey U.
 * 
 * Copyright (c) 2019-2020. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'pos_styles.dart';

/// Column contains text, styles and width (an integer in 1..12 range)
class PosColumn {
  PosColumn({
    this.text = '',
    this.containsChinese = false,
    this.width = 2,
    this.styles = const PosStyles(),
  }) {
    if (width < 1 || width > 12) {
      throw Exception('Column width must be between 1..12');
    }
  }

  String text;
  bool containsChinese;
  int width;
  PosStyles styles;
}
