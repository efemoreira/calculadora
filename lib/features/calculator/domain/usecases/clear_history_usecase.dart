/// Use case para limpar o histórico de operações.
///
/// Encapsula a lógica de negócio de remover todas as operações
/// realizadas durante a sessão.
library clear_history_usecase;

import 'package:flutter_calculator_app/features/calculator/domain/repositories/history_repository.dart';

/// Use case que limpa o histórico completo de cálculos.
///
/// Responsável por:
/// - Remover todas as operações do repository
/// - Resetar o estado do histórico
/// - Abstrair a implementação de limpeza
class ClearHistoryUseCase {
  /// Cria um ClearHistoryUseCase.
  ///
  /// Requer um [HistoryRepository] injetado para limpeza.
  const ClearHistoryUseCase(this._historyRepository);

  /// Repository que fornece acesso ao histórico.
  final HistoryRepository _historyRepository;

  /// Limpa completamente o histórico de operações.
  ///
  /// Remove todas as entradas do histórico e o deixa vazio.
  /// Irreversível - não há forma de recuperar após executado.
  ///
  /// Exemplo:
  /// ```dart
  /// useCase();  // Remove todas as operações
  /// // Histórico agora está vazio
  /// ```
  void call() {
    // Limpa todas as operações do repository
    _historyRepository.clear();
  }
}
