
class ProductImageEntity{
  final String src;

  ProductImageEntity(Map<String,dynamic> json):
  src=json["src"];
}