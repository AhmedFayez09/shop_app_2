class MedicalProductModel {
  String id;
  String imageUrl;
  String name;
  int price;
  bool inFavorites;
  bool inCart;
  int quantity;
  int totalPrice;

  MedicalProductModel({
    this.id = '',
    this.quantity = 1,
   required this.totalPrice ,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.inCart = false,
    this.inFavorites = false,
  });

  MedicalProductModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          quantity: json['quantity'],
    totalPrice: json['totalPrice'],
          imageUrl: json['imageUrl'],
          name: json['name'],
          price: json['price'],
          inCart: json['inCart'],
          inFavorites: json['inFavorites'],
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalPrice': totalPrice,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'name': name,
      'price': price,
      'inCart': inCart,
      'inFavorites': inFavorites,
    };
  }
}
