/// Use case para obter o histórico de operações.
///
/// Encapsula a lógica de negócio de recuperar todas as operações
/// já realizadas durante a sessão.
library get_history_usecase;

import 'package:flutter_calculator_app/features/calculator/domain/entities/calculation_result.dart';
import 'package:flutter_calculator_app/features/calculator/domain/repositories/history_repository.dart';

/// Use case que recupera o histórico completo de cálculos.
///
/// Responsável por:
/// - Buscar todas as operações no repository
/// - Retornar em ordem (mais recente primeiro)
/// - Abstrair a fonte de dados (memória, BD, etc)
class GetHistoryUseCase {
  /// Cria um GetHistoryUseCase.
  ///
  /// Requer um [HistoryRepository] injetado para leitura.
  const GetHistoryUseCase(this._historyRepository);

  /// Repository que fornece acesso ao histórico.
  final HistoryRepository _historyRepository;

  /// Obtém todo o histórico de operações realizadas.
  ///
  /// Retorna:
  /// - Lista de [CalculationResult] em ordem reversa (top = mais recente)
  /// - Lista vazia se nenhuma operação foi realizada
  ///
  /// Exemplo:
  /// ```dart
  /// final history = useCase();
  /// // history[0] é a operação mais recente
  /// // history[1] é a operação anterior
  /// ```
  List<CalculationResult> call() {
    // Recupera todas as operações do repository
    return _historyRepository.getAll();
  }
}
