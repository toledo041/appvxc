class VendedorModel {
  final String nombre;
  final String correo;
  double deuda;
  double abono;
  double porPagar; //
  String uid;
  String marcas;
  bool liquidada;
  List carrito = [];
  List listaMarcas = [];

  VendedorModel(
      {required this.nombre,
      required this.correo,
      this.deuda = 0,
      this.abono = 0,
      this.porPagar = 0,
      this.uid = "",
      required this.carrito,
      this.marcas = "",
      this.liquidada = false,
      required this.listaMarcas});
}

class ProductoModel {
  String marca;
  String codigo;
  String precio;
  String tamano;
  String cantidad;
  bool mostrarMarca;

  ProductoModel(
      {required this.marca,
      required this.codigo,
      required this.precio,
      this.tamano = "",
      this.cantidad = "",
      this.mostrarMarca = false});
}

//{marca: N/A, deuda: 2663.01, liquidada: true, name: Humbere, abono: 2663.01, email: beto@gmail.com}
class PagoModel {
  String marca;
  double deuda;
  bool liquidada;
  String nombre;
  double abono;
  String correo;
  String uid;

  PagoModel(
      {this.marca = "",
      required this.deuda,
      required this.abono,
      required this.liquidada,
      required this.correo,
      this.nombre = "",
      this.uid = ""});
}
