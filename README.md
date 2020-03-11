# esc_pos_utils

Basic Flutter/Dart classes for ESC/POS printing. `Ticket` class generates ESC/POS commands that can be sent to a thermal printer.


## Libraries using `esc_pos_utils`
* WiFi/Ethernet printing: [esc_pos_printer](https://github.com/andrey-ushakov/esc_pos_printer)
* Bluetooth printing: [esc_pos_bluetooth](https://github.com/andrey-ushakov/esc_pos_bluetooth)


## Getting started (Generate a simple ticket)

Check the complete example in `example/example.dart`

```dart
final Ticket ticket = Ticket(PaperSize.mm80);

ticket.text('Hello world!');
ticket.text('Bold text', styles: PosStyles(bold: true));
ticket.text('Reverse text', styles: PosStyles(reverse: true));
ticket.text('Underlined text',
    styles: PosStyles(underline: true), linesAfter: 1);

ticket.text('Align left', styles: PosStyles(align: PosAlign.left));
ticket.text('Align center', styles: PosStyles(align: PosAlign.center));
ticket.text('Align right',
    styles: PosStyles(align: PosAlign.right), linesAfter: 1);

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

ticket.text('Text size 200%',
    styles: PosStyles(
    height: PosTextSize.size2,
    width: PosTextSize.size2,
    ));

// Print barcode
final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
ticket.barcode(Barcode.upcA(barData));

ticket.feed(2);
ticket.cut();
```