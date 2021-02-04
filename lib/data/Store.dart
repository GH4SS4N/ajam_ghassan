import 'StoreType.dart';
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

  static const String storeTypeKey = "storeType";
  StoreType get storeType => get(storeTypeKey);
  set storeType(StoreType storeType) => set(storeTypeKey, storeType);

  static const String userKey = "user";
  ParseUser get user => get(userKey);
  set user(ParseUser user) => set(userKey, user);
}
