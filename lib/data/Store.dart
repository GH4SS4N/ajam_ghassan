import 'package:ajamapp/Model/StoreType.dart';
import 'package:ajamapp/Utils/conversion.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:parse_server_sdk/parse_server_sdk.dart';

class Store extends ParseObject implements ParseCloneable {
  static const String _keyTableName = 'Store';
  Store() : super(_keyTableName);

  @override
  clone(Map map) => Store.clone()..fromJson(map);
  Store.clone() : this();

  static const String nameKey = "name";
  String get name => get(nameKey) ?? "";
  set name(String name) => set(nameKey, name);

  static const String logoKey = "logo";
  ParseFile get logo => get(logoKey);
  set logo(ParseFile logo) => set(logoKey, logo);

  static const String websiteURLKey = "websiteURL";
  String get websiteURL => get(websiteURLKey) ?? "";
  set websiteURL(String websiteURL) => set(websiteURLKey, websiteURL);

  static const String storeTypeKey = "storeType";
  StoreType get storeType => get(storeTypeKey);
  set storeType(StoreType storeType) => set(storeTypeKey, storeType);

  static const String openKey = "open";
  bool get open => get(openKey);
  set open(bool open) => set(openKey, open);

  static const String phoneNumberKey = "phoneNumber";
  String get phoneNumber => get(phoneNumberKey) ?? "";
  set phoneNumber(String phoneNumber) => set(phoneNumberKey, phoneNumber);

  static const String locationKey = "location";
  GeoCoord get location => toGeoCoord(get(locationKey));
  set location(GeoCoord location) =>
      set(locationKey, toParseGeoPoint(location));

  static const String userKey = "user";
  ParseUser get user => get(userKey);
  set user(ParseUser user) => set(userKey, user);
}
