class ProductEntity {
  final int id;
  final String name;
  final String permalink;
  final String imageSrc;
  final String regularPrice;
  final String salePrice;
  final String price;
  final bool onSale;

  ProductEntity.fromJson(Map<String, dynamic> json)
      : id = json["id"],
      name=json["name"],
        permalink = json["permalink"],
        imageSrc = json["images"].isNotEmpty?json["images"][0]["src"]:"",
        regularPrice = json["regular_price"],
        salePrice=json["sale_price"],
        price=json["price"],
        onSale=json["on_sale"];
}
