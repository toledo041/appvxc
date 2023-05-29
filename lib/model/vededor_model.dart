class VendedorModel {
  final String nombre;
  final String correo;
  double deuda;
  final double abono; //
  final String uid;
  String marcas;
  bool liquidada;
  List carrito = [];

  VendedorModel(
      {required this.nombre,
      required this.correo,
      this.deuda = 0,
      required this.abono,
      required this.uid,
      required this.carrito,
      this.marcas = "",
      this.liquidada = false});
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

//{marca: N/A, deuda: 2663.01, liquidada: true, name: Humbere, abono: 2663.01, email: beto@gmail.com}
class PagoModel {
  String marca;
  double deuda;
  bool liquidada;
  String nombre;
  double abono;
  String correo;

  PagoModel(
      {this.marca = "",
      required this.deuda,
      required this.abono,
      required this.liquidada,
      required this.correo,
      this.nombre = ""});
}
