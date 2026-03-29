/// Use case para adicionar uma operação ao histórico.
///
/// Encapsula a lógica de negócio de persistir uma operação realizada.
/// Implementa o padrão repository para abstrair a fonte de dados.
library add_history_entry_usecase;

import 'package:flutter_calculator_app/features/calculator/domain/entities/calculation_result.dart';
import 'package:flutter_calculator_app/features/calculator/domain/repositories/history_repository.dart';

/// Use case que adiciona uma entrada ao histórico de cálculos.
///
/// Responsável por:
/// - Receber um CalculationResult
/// - Delegar ao repository para persistência
/// - Garantir que a entrada seja salva corretamente
class AddHistoryEntryUseCase {
  /// Cria um AddHistoryEntryUseCase.
  ///
  /// Requer um [HistoryRepository] injetado para persistência.
  const AddHistoryEntryUseCase(this._historyRepository);

  /// Repository que fornece a persistência do histórico.
  final HistoryRepository _historyRepository;

  /// Adiciona um resultado de cálculo ao histórico.
  ///
  /// Parâmetro:
  /// - [result]: CalculationResult contendo expresão, valor e timestamp
  ///
  /// Exemplo:
  /// ```dart
  /// final item = CalculationResult(
  ///   expression: '5 + 3 =',
  ///   value: 8.0,
  ///   createdAt: DateTime.now(),
  /// );
  /// useCase(item);  // Adiciona ao histórico
  /// ```
  void call(CalculationResult result) {
    // Adiciona item ao repository (memória ou banco de dados)
    _historyRepository.add(result);
  }
}
