class VendedorModel {
  final String nombre;
  final String correo;
  double deuda;
  final double abono; //
  final String uid;
  List carrito = [];

  VendedorModel(
      {required this.nombre,
      required this.correo,
      this.deuda = 0,
      required this.abono,
      required this.uid,
      required this.carrito});
}
