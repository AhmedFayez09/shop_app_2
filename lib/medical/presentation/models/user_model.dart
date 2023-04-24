class UserModel {
  String uId;
  final String name;
  final String email;
  final String phone;
  final int totalPrice;

  UserModel({
    this.totalPrice = 0,
    required this.uId,
    required this.phone,
    required this.email,
    required this.name,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
          totalPrice: json['totalPrice'],
          uId: json['uId'],
          name: json['name'],
          email: json['email'],
          phone: json['phone'],
        );

  Map<String, dynamic> toJson() => {
        'uId': uId,
        'totalPrice': totalPrice,
        'name': name,
        'email': email,
        'phone': phone,
      };
}
