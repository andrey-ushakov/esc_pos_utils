## [0.3.6]
* Print QR Codes using native function


## [0.3.5]
* Added `Ticket.setGlobalFont` method
* `Ticket.codeTable` renamed to `Ticket.printCodeTable`
* Added `maxCharsPerLine` custom config + default values depending on current font and ticket size
* Code refactoring


## [0.3.4]
* Added hr method
* Updated commands (using hex codes)
* setStyles bug fix


## [0.3.3]
* Slow printing issue on some printer models fixed


## [0.3.2]
* `PosColumn` can contain encoded text (`textEncoded` field)
* Bug fix: Columns with `PosTextSize` > `size1`
* Added Barcode Code128
* Added new code pages
* `imageRaster` bug fixed
* Ticket bytecode optimization: do not generate align left command (it's a default value)
* Added new image print function: `GS ( L`


## [0.3.1]
* Added Open cash drawer command


## [0.3.0]
* Image alignment (left, center, right). Align center by default.
* Barcode alignment (left, center, right). Align center by default.
* `PosTextAlign` renamed to `PosAlign`


## [0.2.0]
* `Ticket._text` function takes an Uint8List of bytes instead of a String
* `Ticket._text` function refactored: removed styling commands when it's unnecessary which makes ticket's final byte code much shorter
* `PosCodeTable`: private constructor replaced by public one to allow passing custom code table code
* `PosCodeTable`: added new predefined code tables
* Added `Ticket.textEncoded` function taking Uint8List textBytes (encoded text) to support different languages


## [0.1.0 - 0.1.2]
* Initial release
