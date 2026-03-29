/// Contrato (interface) para o repositório de histórico.
///
/// Define operações de CRUD para gerenciar o histórico de cálculos.
/// Abstrai da implementação concreta (memória, BD, preferências, etc).
///
/// Implementações possíveis:
/// - HistoryRepositoryMemoryImpl: armazena em memória (atual)
/// - HistoryRepositorySQLiteImpl: banco de dados SQLite
/// - HistoryRepositorySharedPrefsImpl: SharedPreferences Android/iOS
library history_repository;

import 'package:flutter_calculator_app/features/calculator/domain/entities/calculation_result.dart';

/// Contrato para o repositório de histórico de cálculos.
///
/// Responsável por operações de:
/// - **Create**: adicionar nova operação
/// - **Read**: recuperar histórico
/// - **Delete**: limpar todo histórico
///
/// Padrão: Repository Pattern (abstrai a fonte de dados)
/// Benefício: Fácil trocar implementação (memória ↔ BD ↔ API)
abstract class HistoryRepository {
  /// Adiciona um resultado de operação ao histórico.
  ///
  /// Parâmetro:
  /// - [item]: CalculationResult a ser armazenado
  void add(CalculationResult item);

  /// Recupera todo o histórico de operações.
  ///
  /// Retorna:
  /// - Lista imutável de [CalculationResult]
  /// - Ordem: mais recente primeiro
  /// - Vazia se nenhuma operação foi realizada
  List<CalculationResult> getAll();

  /// Limpa o histórico completamente.
  ///
  /// Operação irreversível.
  void clear();
}
