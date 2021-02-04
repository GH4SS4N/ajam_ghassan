import 'package:parse_server_sdk/parse_server_sdk.dart';

class Captain extends ParseObject implements ParseCloneable {
  static const String _keyTableName = 'Captain';
  Captain() : super(_keyTableName);

  @override
  clone(Map map) => Captain.clone()..fromJson(map);
  Captain.clone() : this();

  static const String photoKey = "photo";
  ParseFile get photo => get(photoKey);
  set photo(ParseFile photo) => set(photoKey, photo);

  static const String idKey = "id";
  String get id => get(idKey);
  set id(String id) => set(idKey, id);

  static const String ibanKey = "iban";
  String get iban => get(ibanKey);
  set iban(String iban) => set(ibanKey, iban);

  static const String carFrontKey = "carFront";
  ParseFile get carFront => get(carFrontKey);
  set carFront(ParseFile carFront) => set(carFrontKey, carFront);

  static const String carBackKey = "carBack";
  ParseFile get carBack => get(carBackKey);
  set carBack(ParseFile carBack) => set(carBackKey, carBack);

  static const String carInsideKey = "carInside";
  ParseFile get carInside => get(carInsideKey);
  set carInside(ParseFile carInside) => set(carInsideKey, carInside);
}
