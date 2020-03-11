## [0.2.0]
* `Ticket._text` function takes an Uint8List of bytes instead of a String
* `Ticket._text` function refactored: removed styling commands when it's unnecessary which makes ticket's final byte code much shorter
* `PosCodeTable`: private constructor replaced by public one to allow passing custom code table code
* `PosCodeTable`: added new predefined code tables
* Added `Ticket.textEncoded` function taking Uint8List textBytes (encoded text) to support different languages


## [0.1.0 - 0.1.2]
* Initial release
