/*
 * esc_pos_utils
 * Created by Andrey U.
 * 
 * Copyright (c) 2019-2020. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'dart:convert' show json;
import 'package:resource/resource.dart' show Resource;
import 'dart:convert' show utf8;

class CapabilityProfile {
  CapabilityProfile._internal(this.name, this.codePages);

  /// Public factory
  static Future<CapabilityProfile> load({String name = 'default'}) async {
    var resource =
        Resource("package:esc_pos_utils/resources/capabilities.json");
    var string = await resource.readAsString(encoding: utf8);
    Map capabilities = json.decode(string);

    var profile = capabilities['profiles'][name];

    if (profile == null) {
      throw Exception("The CapabilityProfile '$name' does not exist");
    }

    // Call the private constructor
    return CapabilityProfile._internal(
        name, Map<String, int>.from(profile['codePages']));
  }

  String name;
  Map<String, int> codePages;
}
