/// Implementação em memória do repositório de histórico.
///
/// Armazena operações em uma lista durante a sessão.
/// Os dados são perdidos quando a app é fechada (não persistidos em disco).
///
/// Nota: Para persistência durável, implementar com SharedPreferences ou banco de dados.
library history_repository_memory_impl;

import 'package:flutter_calculator_app/features/calculator/domain/entities/calculation_result.dart';
import 'package:flutter_calculator_app/features/calculator/domain/repositories/history_repository.dart';

/// Implementação do HistoryRepository usando memória (List).
///
/// Responsável por:
/// - Armazenar operações em memória (durante a sessão)
/// - Retornar histórico em ordem (mais recente primeiro)
/// - Limpar o histórico quando solicitado
///
/// Características:
/// - Operações: O(1) para add, O(n) para getAll
/// - Dados: perdidos ao fechar app (sessão única)
/// - Ordem: LIFO (Last In, First Out) - mais recente no topo
///
/// Melhoria futura:
/// - Implementar HistoryRepositorySQLiteImpl para persistência durável
/// - Implementar HistoryRepositorySharedPrefsImpl para preferências
class HistoryRepositoryMemoryImpl implements HistoryRepository {
  /// Lista interna que armazena as operações realizadas.
  /// Primeiro elemento (index 0) é a operação mais recente.
  final List<CalculationResult> _items = [];

  /// Adiciona um resultado de operação ao histórico.
  ///
  /// O item é inserido no início da lista (index 0),
  /// tornando ele a operação mais recente.
  ///
  /// Complexidade: O(n) - por causa do insert em index 0
  ///
  /// Parâmetro:
  /// - [item]: CalculationResult com expressão, valor e timestamp
  ///
  /// Exemplo:
  /// ```dart
  /// final item = CalculationResult(
  ///   expression: '5 + 3 =',
  ///   value: 8.0,
  ///   createdAt: DateTime.now(),
  /// );
  /// repository.add(item);
  /// // Agora item é o primeiro no histórico
  /// ```
  @override
  void add(CalculationResult item) {
    // Insert no início (index 0) para manter ordem: recente primeiro
    _items.insert(0, item);
  }

  /// Remove todos os itens do histórico.
  ///
  /// Operação irreversível - não há como recuperar após executada.
  ///
  /// Complexidade: O(n)
  @override
  void clear() {
    // Limpa toda a lista
    _items.clear();
  }

  /// Retorna todos os itens do histórico em ordem.
  ///
  /// A lista retornada é imutável (unmodifiable), impedindo
  /// modificações externas mantendo a integridade dos dados.
  ///
  /// Complexidade: O(n)
  ///
  /// Retorna:
  /// - Lista imutável de [CalculationResult] (primeiro = mais recente)
  /// - Lista vazia se nenhuma operação foi realizada
  ///
  /// Exemplo:
  /// ```dart
  /// final history = repository.getAll();
  /// print(history[0].expression);  // Primeira operação (mais recente)
  /// history.clear();  // Erro! Lista é imutável
  /// ```
  @override
  List<CalculationResult> getAll() {
    // Retorna lista não-modificável para garantir integridade
    return List.unmodifiable(_items);
  }
}
