import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataService {
  // Lista em memória para guardar todos os jogos retornados pela API
  List _allGames = [];

  List get jogos => _allGames;

  final ValueNotifier tableStateNotifier = ValueNotifier({
    "objects": [],
    "properties": ["title", "genre", "platform"],
    "columns": ["Título", "Gênero", "Plataforma"],
    "total": 0,
    "pageSize": 5,
    "page": 0,
    "pages": 0,
    "cursor": 0
  });

  Future<void> carregarJogos() async {
    var uri = Uri(
      scheme: 'https',
      host: 'api.regvault.org',
      path: '/api/v1/browse',
      queryParameters: {
        'page': '1',
        'limit': '100'
      },
    );

    try {
      var jsonString = await http.read(uri);

      var data = jsonDecode(jsonString);

      _allGames = data["games"];

      for (var game in _allGames) {
        if (game["genre"] is List) {
          game["genre"] = (game["genre"] as List).join(", ");
        }
      }

      _atualizarEstadoPaginado(0);
    } catch (e) {
      print("Erro ao carregar dados da REG-Vault: $e");
    }
  }

  // Função interna responsável por fatiar a lista e atualizar o ValueNotifier
  void _atualizarEstadoPaginado(int newCursor) {
    final int pageSize = tableStateNotifier.value["pageSize"] as int;
    final total = _allGames.length;

    if (newCursor < 0) newCursor = 0;
    if (newCursor >= total && total > 0) return;

    int end = newCursor + pageSize;
    if (end > total) end = total;

    List pageObjects = _allGames.sublist(newCursor, end);

    tableStateNotifier.value = {
      "objects": pageObjects,
      "properties": ["title", "genre", "platform"],
      "columns": ["Título", "Gênero", "Plataforma"],
      "total": total,
      "pageSize": pageSize,
      "page": (newCursor ~/ pageSize) + 1,
      "pages": (total / pageSize).ceil(),
      "cursor": newCursor
    };
  }

  void carregarPaginaSeguinte() {
    if (_allGames.isEmpty) return;

    final int pageSize = tableStateNotifier.value["pageSize"] as int;
    final newCursor = tableStateNotifier.value["cursor"] + pageSize;

    _atualizarEstadoPaginado(newCursor);
  }

  void carregarPaginaAnterior() {
    if (_allGames.isEmpty) return;

    final int pageSize = tableStateNotifier.value["pageSize"] as int;
    final newCursor = tableStateNotifier.value["cursor"] - pageSize;

    _atualizarEstadoPaginado(newCursor);
  }
}

final dataService = DataService();