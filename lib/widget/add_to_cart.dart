import 'package:advance_notification/advance_notification.dart';
import 'package:flutter/material.dart';

import '../data/app_data.dart';
import '../model/base_model.dart';

class AddToCart {
  static void addToCart(BaseModel data, BuildContext context) {
    bool contains = itemsOnCart.contains(data);

    if (contains == true) {
      const AdvanceSnackBar(
        textSize: 14.0,
        bgColor: Colors.red,
        message: 'Ha agregado este artículo al carrito antes',
        mode: Mode.ADVANCE,
        duration: Duration(seconds: 1),
      ).show(context);
    } else {
      itemsOnCart.add(data);

      const AdvanceSnackBar(
        textSize: 14.0,
        message: 'Añadido correctamente a su carrito',
        mode: Mode.ADVANCE,
        duration: Duration(seconds: 1),
      ).show(context);
    }
  }
}
