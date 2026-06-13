import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  final RxList<Map<String, dynamic>> favoritos = <Map<String, dynamic>>[].obs;

  bool isFavorito(Map<String, dynamic> jogo) {
    return favoritos.any(
      (f) => f["title_en"] == jogo["title_en"] && f["system"] == jogo["system"],
    );
  }

  void toggleFavorito(Map<String, dynamic> jogo) {
    if (isFavorito(jogo)) {
      favoritos.removeWhere(
        (f) =>
            f["title_en"] == jogo["title_en"] && f["system"] == jogo["system"],
      );
      Get.snackbar(
        "Removido dos favoritos",
        jogo["title_en"] ?? "Jogo",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        icon: Icon(Icons.heart_broken, color: Colors.white),
      );
    } else {
      favoritos.add(Map<String, dynamic>.from(jogo));
      Get.snackbar(
        "Adicionado aos favoritos",
        jogo["title_en"] ?? "Jogo",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        icon: Icon(Icons.favorite, color: Colors.red),
      );
    }
  }
}
