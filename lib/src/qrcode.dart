import 'package:esc_pos_utils/src/commands.dart';
import 'enums.dart';
import 'dart:convert';

class QRSize {
  const QRSize(this.value);
  final int value;

  static const Size4 = QRSize(0x04);
  static const Size5 = QRSize(0x05);
  static const Size6 = QRSize(0x06);
  static const Size7 = QRSize(0x07);
  static const Size8 = QRSize(0x08);
}

/// QR Correction level
class QRCorrection {
  const QRCorrection._internal(this.value);
  final int value;

  /// Level L: Recovery Capacity 7%
  static const L = QRCorrection._internal(48);

  /// Level M: Recovery Capacity 15%
  static const M = QRCorrection._internal(49);

  /// Level Q: Recovery Capacity 25%
  static const Q = QRCorrection._internal(50);

  /// Level H: Recovery Capacity 30%
  static const H = QRCorrection._internal(51);
}

class QRCode {
  List<int> bytes = <int>[];

  QRCode(String text, QRSize size, QRCorrection level) {
    // FN 167. QR Code: Set the size of module
    // bytes += List.from(cQrHeader.codeUnits)
    //   ..addAll([0x03, 0x00, 0x31, 0x43]) // pL pH cn fn
    //   ..add(size.value);
    bytes += cQrHeader.codeUnits + [0x03, 0x00, 0x31, 0x43] + [size.value];

    // FN 169. QR Code: Select the error correction level
    // bytes += List.from(cQrHeader.codeUnits)
    //   ..addAll([0x03, 0x00, 0x31, 0x45]) // pL pH cn fn
    //   ..add(level.value);
    bytes += cQrHeader.codeUnits + [0x03, 0x00, 0x31, 0x45] + [level.value];

    // FN 180. QR Code: Store the data in the symbol storage area
    List<int> textBytes = latin1.encode(text);
    // bytes += List.from(cQrHeader.codeUnits)
    // pL pH cn fn m
    // ..addAll([textBytes.length + 3, 0x00, 0x31, 0x50, 0x30]);
    bytes +=
        cQrHeader.codeUnits + [textBytes.length + 3, 0x00, 0x31, 0x50, 0x30];
    bytes += textBytes;

    // TODO
    // Set QR code location
    // _data += [0x1b, 0x61, align.index];

    // FN 182. QR Code: Transmit the size information of the symbol data in the symbol storage area
    // bytes += List.from(cQrHeader.codeUnits)
    //   // pL pH cn fn m
    //   ..addAll([0x03, 0x00, 0x31, 0x52, 0x30]);
    bytes += cQrHeader.codeUnits + [0x03, 0x00, 0x31, 0x52, 0x30];

    // FN 181. QR Code: Print the symbol data in the symbol storage area
    // bytes += List.from(cQrHeader.codeUnits)
    //   // pL pH cn fn m
    //   ..addAll([0x03, 0x00, 0x31, 0x51, 0x30]);
    bytes += cQrHeader.codeUnits + [0x03, 0x00, 0x31, 0x51, 0x30];
  }
}
