import 'package:flutter/material.dart';
import '../data/data_service.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    await dataService.carregarJogos();

    dataService.jogos.sort((a, b) {
      int scoreA = 0;
      int scoreB = 0;

      scoreA += (a["has_box_front"] ?? 0) as int;
      scoreA += (a["has_screenshot"] ?? 0) as int;

      scoreB += (b["has_box_front"] ?? 0) as int;
      scoreB += (b["has_screenshot"] ?? 0) as int;

      return scoreB.compareTo(scoreA);
    });

    setState(() {
      carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],

      appBar: AppBar(
        title: const Text("Catálogo Retrô"),
      ),

      body: carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: dataService.jogos.length,

              itemBuilder: (context, index) {
                final jogo = dataService.jogos[index];

                String generos = "Não informado";

                if (jogo["genre"] is List &&
                    (jogo["genre"] as List).isNotEmpty) {
                  generos = (jogo["genre"] as List).join(", ");
                }

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 12),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Row(
                          children: [

                            const Icon(
                              Icons.sports_esports,
                              size: 40,
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Text(
                                jogo["title_en"] ?? "Sem título",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            const Icon(Icons.computer, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Sistema: ${jogo["system"] ?? "N/A"}",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.calendar_month, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Ano: ${jogo["year"] ?? "N/A"}",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.business, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Publisher: ${jogo["publisher"] ?? "N/A"}",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.category, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Gêneros: $generos",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Wrap(
                          spacing: 8,

                          children: [

                            if (jogo["has_box_front"] == 1)
                              const Chip(
                                label: Text("Capa"),
                              ),

                            if (jogo["has_screenshot"] == 1)
                              const Chip(
                                label: Text("Screenshot"),
                              ),

                            if (jogo["has_manual"] == 1)
                              const Chip(
                                label: Text("Manual"),
                              ),

                            if (jogo["has_video_lq"] == 1 ||
                                jogo["has_video_hq"] == 1)
                              const Chip(
                                label: Text("Vídeo"),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}