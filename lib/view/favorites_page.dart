import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/favorites_controller.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController favController = Get.find<FavoritesController>();

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("Favoritos"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple.shade900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (favController.favoritos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: Colors.deepPurple.shade300,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Nenhum favorito ainda",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Explore o catálogo e favorite seus jogos!",
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => Get.toNamed('/catalogo'),
                  icon: const Icon(Icons.sports_esports),
                  label: const Text("Ir ao Catálogo"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade700,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Row(
                children: [
                  Icon(Icons.favorite, color: Colors.red.shade400, size: 20),
                  const SizedBox(width: 8),
                  Obx(
                    () => Text(
                      "${favController.favoritos.length} jogo(s) favorito(s)",
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: favController.favoritos.length,
                itemBuilder: (context, index) {
                  final jogo = favController.favoritos[index];

                  String generos = "Não informado";
                  if (jogo["genre"] is List &&
                      (jogo["genre"] as List).isNotEmpty) {
                    generos = (jogo["genre"] as List).join(", ");
                  }

                  return GestureDetector(
                    onTap: () => Get.toNamed('/detalhe', arguments: jogo),
                    child: Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      color: Colors.grey[850],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: BorderSide(
                          color: Colors.deepPurple.shade700,
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.sports_esports, size: 40),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    jogo["title_en"] ?? "Sem título",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => IconButton(
                                    icon: Icon(
                                      favController.isFavorito(jogo)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red.shade400,
                                    ),
                                    onPressed: () =>
                                        favController.toggleFavorito(jogo),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.computer, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Sistema: ${jogo["system"] ?? "N/A"}",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.calendar_month, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Ano: ${jogo["year"] ?? "N/A"}",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.category, size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "Gêneros: $generos",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
