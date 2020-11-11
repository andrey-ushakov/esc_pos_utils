# esc_pos_utils

[![Pub Version](https://img.shields.io/pub/v/esc_pos_utils)](https://pub.dev/packages/esc_pos_utils)

Base Flutter/Dart classes for ESC/POS printing. `Generator` class generates ESC/POS commands that can be sent to a thermal printer.

This is the "base" library that used for:

- Flutter WiFi/Ethernet printing: [esc_pos_printer](https://github.com/andrey-ushakov/esc_pos_printer)
- Flutter Bluetooth printing: [esc_pos_bluetooth](https://github.com/andrey-ushakov/esc_pos_bluetooth)

## Main Features

- Connect to Wi-Fi / Ethernet printers
- Simple text printing using _text_ method
- Tables printing using _row_ method
- Text styling:
  - size, align, bold, reverse, underline, different fonts, turn 90°
- Print images
- Print barcodes
  - UPC-A, UPC-E, JAN13 (EAN13), JAN8 (EAN8), CODE39, ITF (Interleaved 2 of 5), CODABAR (NW-7), CODE128
- Paper cut (partial, full)
- Beeping (with different duration)
- Paper feed, reverse feed

**Note**: Your printer may not support some of the presented features (some styles, partial/full paper cutting, reverse feed, barcodes...).

## Generate a Ticket

### Simple ticket with styles:

```dart
List<int> testTicket() {
  final List<int> bytes = [];
  // Using default profile
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm80, profile);
  List<int> bytes = [];

  bytes += generator.text(
      'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
  bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
      styles: PosStyles(codeTable: PosCodeTable.westEur));
  bytes += generator.text('Special 2: blåbærgrød',
      styles: PosStyles(codeTable: PosCodeTable.westEur));

  bytes += generator.text('Bold text', styles: PosStyles(bold: true));
  bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
  bytes += generator.text('Underlined text',
      styles: PosStyles(underline: true), linesAfter: 1);
  bytes += generator.text('Align left', styles: PosStyles(align: PosAlign.left));
  bytes += generator.text('Align center', styles: PosStyles(align: PosAlign.center));
  bytes += generator.text('Align right',
      styles: PosStyles(align: PosAlign.right), linesAfter: 1);

  bytes += generator.text('Text size 200%',
      styles: PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ));

  bytes += generator.feed(2);
  bytes += generator.cut();
  return bytes;
}
```

### Print a table row:

```dart
generator.row([
    PosColumn(
      text: 'col3',
      width: 3,
      styles: PosStyles(align: PosAlign.center, underline: true),
    ),
    PosColumn(
      text: 'col6',
      width: 6,
      styles: PosStyles(align: PosAlign.center, underline: true),
    ),
    PosColumn(
      text: 'col3',
      width: 3,
      styles: PosStyles(align: PosAlign.center, underline: true),
    ),
  ]);
```

### Print an image:

This package implements 3 ESC/POS functions:

- `ESC *` - print in column format
- `GS v 0` - print in bit raster format (obsolete)
- `GS ( L` - print in bit raster format

Note that your printer may support only some of the above functions.

```dart
import 'dart:io';
import 'package:image/image.dart';

final ByteData data = await rootBundle.load('assets/logo.png');
final Uint8List bytes = data.buffer.asUint8List();
final Image image = decodeImage(bytes);
// Using `ESC *`
generator.image(image);
// Using `GS v 0` (obsolete)
generator.imageRaster(image);
// Using `GS ( L`
generator.imageRaster(image, imageFn: PosImageFn.graphics);
```

### Print a Barcode:

```dart
final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
generator.barcode(Barcode.upcA(barData));
```

### Print a QR Code:

Using native ESC/POS commands:

```dart
generator.qrcode('example.com');
```

To print a QR Code as an image (if your printer doesn't support native commands), add [qr_flutter](https://pub.dev/packages/qr_flutter) and [path_provider](https://pub.dev/packages/path_provider) as a dependency in your `pubspec.yaml` file.

```dart
String qrData = "google.com";
const double qrSize = 200;
try {
  final uiImg = await QrPainter(
    data: qrData,
    version: QrVersions.auto,
    gapless: false,
  ).toImageData(qrSize);
  final dir = await getTemporaryDirectory();
  final pathName = '${dir.path}/qr_tmp.png';
  final qrFile = File(pathName);
  final imgFile = await qrFile.writeAsBytes(uiImg.buffer.asUint8List());
  final img = decodeImage(imgFile.readAsBytesSync());

  generator.image(img);
} catch (e) {
  print(e);
}
```

## Using Code Tables

Different printers support different sets of code tables. Some printer models are defined in `CapabilityProfile` class. So, if you want to change the default code table, it's important to choose the right profile:

```dart
// Xprinter XP-N160I
final profile = await CapabilityProfile.load('XP-N160I');
final generator = Generator(PaperSize.mm80, profile);
bytes += generator.setGlobalCodeTable('CP1252');
```

All available profiles can be retrieved by calling :

```dart
final profiles = await CapabilityProfile.getAvailableProfiles();
```

## How to Help

- Add a CapabilityProfile to support your printer's model. A new profile should be added to `lib/resources/capabilities.json` file
- Test your printer and add it in the table: [Wifi/Network printer](https://github.com/andrey-ushakov/esc_pos_printer/blob/master/printers.md) or [Bluetooth printer](https://github.com/andrey-ushakov/esc_pos_bluetooth/blob/master/printers.md)
- Test and report bugs
- Share your ideas about what could be improved (code optimization, new features...)
