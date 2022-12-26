import 'package:auto_forward_sms/region.dart';
import 'package:flutter/services.dart';
import 'package:phone_number/phone_number.dart';

class Store {
  final PhoneNumberUtil plugin;

  Store(this.plugin);

  List<Region>? _regions;

  Future<List<Region>> getRegions() async {
    if (_regions == null) {
      final regions = await plugin.allSupportedRegions();

      // Filter out regions with more than 2 characters
      _regions = regions
          .where((e) => e.code.length <= 2)
          .map((e) => Region(e.code, e.prefix.toString(), e.name))
          .toList(growable: false);

      _regions!.sort((a, b) => a.name.compareTo(b.name));
    }
    return _regions ?? [];
  }

  Future<bool> validate(String string, Region region) async {
    try {
      final result = await plugin.validate(string, regionCode: region.code);
      return result;
    } on PlatformException catch (e) {
      print(e.toString());
      return false;
    }
  }
}