import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_ecommerce_app/model/vededor_model.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

//Obtener lista de la base de datos
Future<List> getPeople() async {
  List people = [];
  //el nombre de la colección debe ser el mismo que en nuestra base
  CollectionReference collectionReferencePeople = db.collection("people");

  //el get se trae todo lo que hay en la colección falta filtrar
  QuerySnapshot queryPeople = await collectionReferencePeople
      .where("name", isEqualTo: "Laura Gonzalez")
      //.orderBy("name", descending: false)
      .get();
  //await collectionReferencePeople.get();
  //.where("name", isEqualTo: "Laura Gonzalez")

  queryPeople.docs.forEach((dcumento) {
    //Se mapea como el tipo de dato que se obtiene una llave cadena y valores cualquiera
    final Map<String, dynamic> data = dcumento.data() as Map<String, dynamic>;
    //se crea un objeto con las propiedades que necesitamos
    final person = {"name": data["name"], "uid": dcumento.id}; //id del elemento
    people.add(person);
  });

  //await Future.delayed(const Duration(seconds: 2));

  return people;
}

//guardar información en la bd
Future<void> addPeople(String nombre) async {
  await db.collection("people").add({"name": nombre});
}

//Actualizar elemento people por medio de un id y el valor a sobreescribir
Future<void> updatePeople(String uid, String newName) async {
  await db.collection('people').doc(uid).set({"name": newName});
}

//Eliminar elemento people por medio de un id
Future<void> deletePeople(String uid) async {
  await db.collection('people').doc(uid).delete();
}

//TIPOS DE USUARIO AL REGISTRAR
//guardar información en la bd
Future<void> addTipoUsuario(String correo, bool esVendedor, String name) async {
  await db
      .collection("tipo_usuario")
      .add({"email": correo, "es_vendedor": esVendedor, "name": name});
}

Future<String> getNombreUsuario(String correo) async {
  String nombre = "";
  //el nombre de la colección debe ser el mismo que en nuestra base
  CollectionReference collectionReferencePeople = db.collection("tipo_usuario");

  //el get se trae todo lo que hay en la colección falta filtrar
  QuerySnapshot queryPeople =
      await collectionReferencePeople.where("email", isEqualTo: correo).get();

  queryPeople.docs.forEach((dcumento) {
    //Se mapea como el tipo de dato que se obtiene una llave cadena y valores cualquiera
    final Map<String, dynamic> data = dcumento.data() as Map<String, dynamic>;
    nombre = data["name"];
  });
  //print("es vendedor ${esVendedor}");

  return nombre;
}

//Obtener el usuario
Future<bool> getUsuarioVendedor(String correo) async {
  bool esVendedor = false;
  //el nombre de la colección debe ser el mismo que en nuestra base
  CollectionReference collectionReferencePeople = db.collection("tipo_usuario");

  //el get se trae todo lo que hay en la colección falta filtrar
  QuerySnapshot queryPeople =
      await collectionReferencePeople.where("email", isEqualTo: correo).get();
  print("Tipo usuario ${queryPeople.docs}");
  for (var dcumento in queryPeople.docs) {
    //Se mapea como el tipo de dato que se obtiene una llave cadena y valores cualquiera
    final Map<String, dynamic> data = dcumento.data() as Map<String, dynamic>;
    print(data);
    esVendedor = data["es_vendedor"]; // == "true" ? true : false;
  }

  print("== es vendedor ${esVendedor}");

  return esVendedor;
}

//CARRITO
//guardar información en la bd
Future<void> addCarritoUsuario(String codigo, String tamano, int cantidad,
    double precio, String correo, String marca, String nombre) async {
  await db.collection("carrito_usuario").add({
    "codigo": codigo,
    "tamano": tamano,
    "cantidad": cantidad,
    "precio": precio,
    "correo": correo,
    "marca": marca,
    "name": nombre
  });
}

//Obtener el usuario
Future<List> getCarritoUsuario(String correo) async {
  List carrito = [];
  //el nombre de la colección debe ser el mismo que en nuestra base
  CollectionReference collectionReferencePeople =
      db.collection("carrito_usuario");

  //el get se trae todo lo que hay en la colección falta filtrar
  QuerySnapshot queryPeople =
      await collectionReferencePeople.where("correo", isEqualTo: correo).get();

  for (var dcumento in queryPeople.docs) {
    //Se mapea como el tipo de dato que se obtiene una llave cadena y valores cualquiera
    final Map<String, dynamic> data = dcumento.data() as Map<String, dynamic>;
    //se crea un objeto con las propiedades que necesitamos
    //print("Producto: ${data}");
    final producto = {
      "codigo": data["codigo"],
      "tamano": data["tamano"],
      "cantidad": data["cantidad"],
      "precio": data["precio"],
      "correo": data["correo"],
      "uid": dcumento.id
    }; //id del elemento
    carrito.add(producto);
  }

  //print("es vendedor ${esVendedor}");

  return carrito;
}

Future<void> actualizaCantCarritoUsuario(String uid, int cantidad) async {
  try {
    await db
        .collection("carrito_usuario")
        .doc(uid)
        .update({"cantidad": cantidad});
  } catch (e) {
    print("Ya no existe elemento");
  }
}

Future<void> borrarElmCarritoUsuario(String uid) async {
  await db.collection("carrito_usuario").doc(uid).delete();
}

//DIRECCIÓN DEL USUARIO
//guardar información en la bd
Future<void> addDireccionUsuario(
    String email,
    String estado,
    String municipio,
    String colonia,
    String calle,
    String numeroInterior,
    String numeroExterior,
    bool principal,
    String descripcion,
    String telefono) async {
  //Se guarda la diraccion del usuario
  await db.collection("direccion_usuario").add({
    "calle": calle,
    "colonia": colonia,
    "correo": email,
    "descripcion": descripcion,
    "dirppal": principal,
    "estado": estado,
    "municipio": municipio,
    "numero_ext": numeroExterior,
    "numero_int": numeroInterior,
    "telefono": telefono,
    "trabajo_casa": "casa",
  });
}

Future<List> getDireccionUsuario(String correo) async {
  List direccionUsuario = [];
  //el nombre de la colección debe ser el mismo que en nuestra base
  CollectionReference collectionReferencePeople =
      db.collection("direccion_usuario");

  //el get se trae todo lo que hay en la colección falta filtrar
  QuerySnapshot queryPeople =
      await collectionReferencePeople.where("correo", isEqualTo: correo).get();

  if (queryPeople.docs.isEmpty) {
    final direccion = {
      "calle": "",
      "colonia": "",
      "correo": "",
      "descripcion": "",
      "dirppal": true,
      "estado": "",
      "municipio": "",
      "numero_ext": "",
      "numero_int": "",
      "telefono": "",
      "uid": ""
    }; //id del elemento
    direccionUsuario.add(direccion);
  } else {
    for (var dcumento in queryPeople.docs) {
      //Se mapea como el tipo de dato que se obtiene una llave cadena y valores cualquiera
      final Map<String, dynamic> data = dcumento.data() as Map<String, dynamic>;
      //se crea un objeto con las propiedades que necesitamos
      final direccion = {
        "calle": data["calle"],
        "colonia": data["colonia"],
        "correo": data["correo"],
        "descripcion": data["descripcion"],
        "dirppal": data["dirppal"],
        "estado": data["estado"],
        "municipio": data["municipio"],
        "numero_ext": data["numero_ext"],
        "numero_int": data["numero_int"],
        "telefono": data["telefono"],
        "uid": dcumento.id
      }; //id del elemento
      direccionUsuario.add(direccion);
    }
  }

  //print("es vendedor ${esVendedor}");

  return direccionUsuario;
}

//TARJETA USUARIO
//guardar información en la bd
Future<void> addTarjetaUsuario(String correo, String tarjeta) async {
  await db
      .collection("tarjeta_usuario")
      .add({"correo": correo, "no_tarjeta": tarjeta});
}

Future<List> getTarjetaUsuario(String correo) async {
  List tarjetaUsuario = [];
  //el nombre de la colección debe ser el mismo que en nuestra base
  CollectionReference collectionReferencePeople =
      db.collection("tarjeta_usuario");

  //el get se trae todo lo que hay en la colección falta filtrar
  QuerySnapshot queryPeople =
      await collectionReferencePeople.where("correo", isEqualTo: correo).get();

  queryPeople.docs.forEach((dcumento) {
    //Se mapea como el tipo de dato que se obtiene una llave cadena y valores cualquiera
    final Map<String, dynamic> data = dcumento.data() as Map<String, dynamic>;
    //se crea un objeto con las propiedades que necesitamos
    final direccion = {
      "correo": data["correo"],
      "tarjeta": data["no_tarjeta"],
      "uid": dcumento.id
    }; //id del elemento
    tarjetaUsuario.add(direccion);
  });
  //print("es vendedor ${esVendedor}");

  return tarjetaUsuario;
}

Future<List<VendedorModel>> getUsuariosVenta() async {
  List<VendedorModel> ventas = [];
  //el nombre de la colección debe ser el mismo que en nuestra base
  CollectionReference collectionReferenceTipoUsuario =
      db.collection("tipo_usuario");

  //el get se trae todo lo que hay en la colección falta filtrar
  QuerySnapshot queryTipoUsuario = await collectionReferenceTipoUsuario
      //.where("es_vendedor", isEqualTo: false)
      .get();

  //Se obtienen los usuarios que no son vendedores
  for (var element in queryTipoUsuario.docs) {
    final Map<String, dynamic> data = element.data() as Map<String, dynamic>;

    String correo = data["email"] ?? "";
    print("correo buscar ${data}");

    if (correo.isNotEmpty) {
      VendedorModel model = VendedorModel(
          nombre: data["name"] ?? "",
          correo: correo,
          deuda: 0,
          abono: 0,
          uid: element.id,
          carrito: [],
          listaMarcas: []);

      ventas.add(model);
    }
  }

  return ventas;
}

Future<List> getTotalCarritoUsuario() async {
  List res = [];
  //Se buscara el carrito por usuario y se calculara su deuda y abono
  CollectionReference collectionReferenceCarrito =
      db.collection("carrito_usuario");

  //el get se trae todo lo que hay en la colección falta filtrar
  QuerySnapshot queryCarrito = await collectionReferenceCarrito
      .where("carrito_usuario")
      //.where("correo", isEqualTo: correo)
      .get();

  for (var carrito in queryCarrito.docs) {
    final Map<String, dynamic> cart = carrito.data() as Map<String, dynamic>;

    final calculado = {
      "cantidad": cart["cantidad"],
      "codigo": cart["codigo"],
      "correo": cart["correo"],
      "marca": cart["marca"],
      "precio": cart["precio"],
      "tamano": cart["tamano"],
    };

    res.add(calculado);
  }
  /*queryCarrito.docs.forEach((carrito) {
      //Se mapea como el tipo de dato que se obtiene una llave cadena y valores cualquiera
      final Map<String, dynamic> cart = carrito.data() as Map<String, dynamic>;
      deuda += (cart["cantidad"] * cart["precio"]);
    });*/
  print("deuda calculada ${res}");

  return res;
}

///Se obtienen los productos filtrados por la marca
Future<List<ProductoModel>> getCatalogoProductos(String marca) async {
//catalogo_productos
  /*await db
      .collection('catalogo_productos')
      .doc("tRkJfTBiNSDuR693YySc")
      .delete();*/

  List<ProductoModel> res = [];
  //Se buscara el carrito por usuario y se calculara su deuda y abono
  CollectionReference collectionReferenceCarrito =
      db.collection("catalogo_productos");

  //el get se trae todo lo que hay en la colección falta filtrar
  QuerySnapshot queryCatalogo = await collectionReferenceCarrito
      .where("marca", isEqualTo: marca)
      //.orderBy("codigo")
      .get();

  for (var catalogo in queryCatalogo.docs) {
    final Map<String, dynamic> elm = catalogo.data() as Map<String, dynamic>;
    print("elemento catalogo:  ${elm} uid: ${catalogo.id}");

    ProductoModel producto = ProductoModel(
        marca: elm["marca"],
        codigo: elm["codigo"],
        precio: elm["precio"].toString(), //double.parse(precio),
        tamano: (elm["tamaño"] == null ? "" : elm["tamaño"]));
    //{marca: shelo, precio: 179, codigo: S146, tamaño: 250ml}

    res.add(producto);
  }

  //

  return res;
}

//PAGOS
//guardar información en la bd
Future<void> addPagoUsuario(double deuda, bool liquidada, String nombre,
    double abono, String correo, String fecha, String nota) async {
  await db.collection("pagos_usuario").add({
    "deuda": deuda,
    "marca": "N/A",
    "liquidada": liquidada,
    "name": nombre,
    "abono": abono,
    "email": correo,
    "fecha": fecha,
    "nota": nota
  });
}

//TODO FALTA POR TERMINAR
Future getPagoUsuario(String correo) async {
  //List res = [];
  //Se buscara el carrito por usuario y se calculara su deuda y abono
  CollectionReference collectionReferenceCarrito =
      db.collection("pagos_usuario");

  //el get se trae todo lo que hay en la colección falta filtrar
  QuerySnapshot queryPagos =
      await collectionReferenceCarrito.where("email", isEqualTo: correo).get();
  //print("Pago usuario: ${queryPagos.docs}");
  for (var pago in queryPagos.docs) {
    final Map<String, dynamic> cart = pago.data() as Map<String, dynamic>;
    print("Pago usuario: ${cart}");
    /*final calculado = {
      "cantidad": cart["cantidad"],
      "codigo": cart["codigo"],
      "correo": cart["correo"],
      "marca": cart["marca"],
      "precio": cart["precio"],
      "tamano": cart["tamano"],
    };

    res.add(calculado);*/
  }
  /*queryCarrito.docs.forEach((carrito) {
      //Se mapea como el tipo de dato que se obtiene una llave cadena y valores cualquiera
      final Map<String, dynamic> cart = carrito.data() as Map<String, dynamic>;
      deuda += (cart["cantidad"] * cart["precio"]);
    });*/
  //print("deuda calculada ${res}");

  //return res;
}

Future<List<PagoModel>> getPagosUsuarios() async {
  List<PagoModel> res = [];
  //Se buscara el carrito por usuario y se calculara su deuda y abono
  CollectionReference collectionReferenceCarrito =
      db.collection("pagos_usuario");

  //el get se trae todo lo que hay en la colección falta filtrar
  QuerySnapshot queryPagos = await collectionReferenceCarrito.get();

  for (var pago in queryPagos.docs) {
    final Map<String, dynamic> cart = pago.data() as Map<String, dynamic>;
    //print("Pago usuario: ${cart}");
    PagoModel pagoUsuario = PagoModel(
        deuda: cart["deuda"] * 1.0,
        abono: cart["abono"] * 1.0,
        liquidada: cart["liquidada"],
        correo: cart["email"],
        nombre: cart["name"],
        uid: pago.id);

    res.add(pagoUsuario);
  }
  return res;
}

Future<void> updatePago(
    String uid, double abono, String fecha, bool liquidada, String nota) async {
  await db.collection('pagos_usuario').doc(uid).update(
      {"abono": abono, "fecha": fecha, "liquidada": liquidada, "nota": nota});
}
