# esc_pos_utils

[![Pub Version](https://img.shields.io/pub/v/esc_pos_utils)](https://pub.dev/packages/esc_pos_utils)

Base Flutter/Dart classes for ESC/POS printing. `Ticket` class generates ESC/POS commands that can be sent to a thermal printer.

This is the "base" library that used for:
* Flutter WiFi/Ethernet printing: [esc_pos_printer](https://github.com/andrey-ushakov/esc_pos_printer)
* Flutter Bluetooth printing: [esc_pos_bluetooth](https://github.com/andrey-ushakov/esc_pos_bluetooth)


## Main Features
* Connect to Wi-Fi / Ethernet printers
* Simple text printing using *text* method
* Tables printing using *row* method
* Text styling:
  * size, align, bold, reverse, underline, different fonts, turn 90°
* Print images
* Print barcodes
  * UPC-A, UPC-E, JAN13 (EAN13), JAN8 (EAN8), CODE39, ITF (Interleaved 2 of 5), CODABAR (NW-7), CODE128
* Paper cut (partial, full)
* Beeping (with different duration)
* Paper feed, reverse feed

**Note**: Your printer may not support some of the presented features (some styles, partial/full paper cutting, reverse feed, barcodes...).

## Generate a Ticket

### Simple ticket with styles:
```dart
Ticket testTicket() {
  final Ticket ticket = Ticket(PaperSize.mm80);

  ticket.text(
      'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
  ticket.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
      styles: PosStyles(codeTable: PosCodeTable.westEur));
  ticket.text('Special 2: blåbærgrød',
      styles: PosStyles(codeTable: PosCodeTable.westEur));

  ticket.text('Bold text', styles: PosStyles(bold: true));
  ticket.text('Reverse text', styles: PosStyles(reverse: true));
  ticket.text('Underlined text',
      styles: PosStyles(underline: true), linesAfter: 1);
  ticket.text('Align left', styles: PosStyles(align: PosAlign.left));
  ticket.text('Align center', styles: PosStyles(align: PosAlign.center));
  ticket.text('Align right',
      styles: PosStyles(align: PosAlign.right), linesAfter: 1);

  ticket.text('Text size 200%',
      styles: PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ));

  ticket.feed(2);
  ticket.cut();
  return ticket;
}
```

### Print a table row:

```dart
ticket.row([
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
* `ESC *` - print in column format
* `GS v 0` - print in bit raster format (obsolete)
* `GS ( L` - print in bit raster format

Note that your printer may support only some of the above functions.

```dart
import 'dart:io';
import 'package:image/image.dart';

final ByteData data = await rootBundle.load('assets/logo.png');
final Uint8List bytes = data.buffer.asUint8List();
final Image image = decodeImage(bytes);
// Using `ESC *`
ticket.image(image);
// Using `GS v 0` (obsolete)
ticket.imageRaster(image);
// Using `GS ( L`
ticket.imageRaster(image, imageFn: PosImageFn.graphics);
```

### Print a Barcode:

```dart
final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
ticket.barcode(Barcode.upcA(barData));
```

### Print a QR Code:

Using native ESC/POS commands:
```dart
ticket.qrcode('example.com');
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

  ticket.image(img);
} catch (e) {
  print(e);
}
```

## Using Code Tables
Thanks to the [charset_converter](https://pub.dev/packages/charset_converter) package, it's possible to print in different languages. The source text should be encoded using the corresponding charset and the correct charset should be passed to the `Ticket.textEncoded` method.

Here are some examples:
```dart
/// Portuguese
Uint8List encTxt1 = await CharsetConverter.encode(
    "cp860", "Portuguese: Olá, Não falo português, Cão");
ticket.textEncoded(encTxt1,
    styles: PosStyles(codeTable: PosCodeTable.pc860_1));

/// Greek
Uint8List encTxt2 =
    await CharsetConverter.encode("windows-1253", "Greek: αβγδώ");
ticket.textEncoded(encTxt2,
    styles: PosStyles(codeTable: PosCodeTable.greek));

/// Polish
Uint8List encTxt3 = await CharsetConverter.encode(
    "cp852", "Polish: Dzień dobry! Dobry wieczór! Cześć!");
ticket.textEncoded(encTxt3,
    styles: PosStyles(codeTable: PosCodeTable.pc852_1));

/// Russian
Uint8List encTxt4 =
    await CharsetConverter.encode("cp866", "Russian: Привет мир!");
ticket.textEncoded(encTxt4,
    styles: PosStyles(codeTable: PosCodeTable.pc866_2));

/// Thai: x-mac-thai | iso-8859-11 | cp874
Uint8List encThai =
    await CharsetConverter.encode("cp874", "Thai: ใบเสร็จ-ใบรับผ้า");
ticket.textEncoded(encThai,
    styles: PosStyles(codeTable: PosCodeTable.thai_1));

/// Arabic
/// Possible charsets for CharsetConverter.encode: cp864, windows-1256
/// Possible codeTables for PosStyles: arabic, pc864_1, pc864_2, pc1001_1, pc1001_2, wp1256, pc720
Uint8List encArabic = await CharsetConverter.encode("windows-1256", "اهلا");
ticket.textEncoded(encArabic,
    styles: PosStyles(codeTable: PosCodeTable.arabic));
```

Note that `CharsetConverter.encode` takes a platform-specific charset (check the [library documentation](https://pub.dev/packages/charset_converter) for more info).

Note that different printers may support different sets of codetables and the above examples may not work on some printer models. It's also possible to pass a codetable by its code (according to your printer's documentation): `PosStyles(codeTable: PosCodeTable(7))`.


## How to Help
* Test your printer and add it in the table: [Wifi/Network printer](https://github.com/andrey-ushakov/esc_pos_printer/blob/master/printers.md) or [Bluetooth printer](https://github.com/andrey-ushakov/esc_pos_bluetooth/blob/master/printers.md)
* Test and report bugs
* Share your ideas about what could be improved (code optimization, new features...)