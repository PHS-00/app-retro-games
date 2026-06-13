import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'view/home_page.dart';
import 'view/catalog_page.dart';
import 'view/games_detail_page.dart';
import 'view/favorites_page.dart';
import 'controllers/favorites_controller.dart';

void main() {
  runApp(const RetroVaultApp());
}

class RetroVaultApp extends StatelessWidget {
  const RetroVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RetroVault',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      initialBinding: BindingsBuilder(() {
        Get.put(FavoritesController(), permanent: true);
      }),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/catalogo', page: () => const CatalogPage()),
        GetPage(name: '/detalhe', page: () => const GameDetailPage()),
        GetPage(name: '/favoritos', page: () => const FavoritesPage()),
      ],
    );
  }
}
