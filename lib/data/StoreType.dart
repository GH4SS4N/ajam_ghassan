import 'package:parse_server_sdk/parse_server_sdk.dart';

class StoreType extends ParseObject implements ParseCloneable {
  static const String _keyTableName = 'StoreType';
  StoreType() : super(_keyTableName);

  @override
  clone(Map map) => StoreType.clone()..fromJson(map);
  StoreType.clone() : this();

  static const String nameKey = "name";
  String get name => get(nameKey);
  set name(String name) => set(nameKey, name);
}
