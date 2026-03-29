/// Contrato (interface) para o repositório de cálculos.
///
/// Define o que qualquer implementação de CalculatorRepository
/// deve fornecer (abstração da fonte de dados).
///
/// Implementações possíveis:
/// - CalculatorRepositoryImpl: cálculos em memória (atual)
/// - CalculatorRepositoryRust: delegar para biblioteca Rust
/// - CalculatorRepositoryAPI: cálculos remotos via HTTP
library calculator_repository;

import 'package:flutter_calculator_app/core/result/result.dart';

/// Contrato para o repositório de operações matemáticas.
///
/// Responsável por:
/// - Executar operações (+, -, *, /)
/// - Validar operandos
/// - Tratar erros (ex: divisão por zero)
/// - Retornar resultado ou erro através do padrão Result
///
/// Implementação:
/// - Atualmente: CalculatorRepositoryImpl (operações aritméticas simples)
/// - Futuro: poderia ser um wrapper para WebAssembly ou API remota
abstract class CalculatorRepository {
  /// Executa uma operação matemática.
  ///
  /// Parâmetros:
  /// - [left]: primeiro operando
  /// - [operator]: operação a executar ('+', '-', '*', '/')
  /// - [right]: segundo operando
  ///
  /// Retorna:
  /// - [Result<double>]: sucesso com resultado ou falha com mensagem
  Result<double> calculate(double left, String operator, double right);
}
