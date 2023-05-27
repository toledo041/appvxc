class VendedorModel {
  final String nombre;
  final String correo;
  double deuda;
  final double abono; //
  final String uid;
  String marcas;
  List carrito = [];

  VendedorModel(
      {required this.nombre,
      required this.correo,
      this.deuda = 0,
      required this.abono,
      required this.uid,
      required this.carrito,
      this.marcas = ""});
}

class ProductoModel {
  String marca;
  String codigo;
  String precio;
  String tamano;

  ProductoModel(
      {required this.marca,
      required this.codigo,
      required this.precio,
      this.tamano = ""});
}
