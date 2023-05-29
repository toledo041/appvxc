class BaseModel {
  final int id;
  final String imageUrl;
  final String name;
  final double price;
  final double review; //
  final double star; //cantidad
  int value;
  final String talla;
  final String uid;
  String marca;
  String codigo;

  BaseModel(
      {required this.id,
      required this.imageUrl,
      required this.name,
      required this.price,
      required this.review,
      this.star = 0.0,
      this.value = 0,
      this.talla = "",
      this.uid = "",
      this.marca = "",
      this.codigo = ""});
}
