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

class CodePage {
  CodePage(this.id, this.name);
  int id;
  String name;
}

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

    List<CodePage> list = [];
    profile['codePages'].forEach((k, v) {
      list.add(CodePage(int.parse(k), v));
    });

    // Call the private constructor
    return CapabilityProfile._internal(name, list);
  }

  String name;
  List<CodePage> codePages;

  int getCodePageId(String codePage) {
    if (codePages == null) {
      throw Exception("The CapabilityProfile isn't initialized");
    }

    return codePages
        .firstWhere((cp) => cp.name == codePage,
            orElse: () => throw Exception(
                "Code Page '$codePage' isn't defined for this profile"))
        .id;
  }

  static Future<List<dynamic>> getAvailableProfiles() async {
    var resource =
        Resource("package:esc_pos_utils/resources/capabilities.json");
    var string = await resource.readAsString(encoding: utf8);
    Map capabilities = json.decode(string);

    var profiles = capabilities['profiles'];

    List<dynamic> res = [];

    profiles.forEach((k, v) {
      res.add({
        'key': k,
        'vendor': v['vendor'] is String ? v['vendor'] : '',
        'model': v['model'] is String ? v['model'] : '',
        'description': v['description'] is String ? v['description'] : '',
      });
    });

    print(res);

    return res;
  }
}
