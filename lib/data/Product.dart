import 'package:parse_server_sdk/parse_server_sdk.dart';

class Product extends ParseObject implements ParseCloneable {
  static const String _keyTableName = 'Product';
  Product() : super(_keyTableName);

  @override
  clone(Map map) => Product.clone()..fromJson(map);
  Product.clone() : this();

  static const String imageKey = "image";
  ParseFile get image => get(imageKey);
  set image(ParseFile image) => set(imageKey, image);

  static const String reviewKey = "review";
  String get review => get(reviewKey);
  set review(String review) => set(reviewKey, review);

  static const String approvedKey = "approved";
  bool get approved => get(approvedKey);
  set approved(bool approved) => set(approvedKey, approved);
}
