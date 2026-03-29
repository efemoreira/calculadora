/// Entidade que representa um resultado de operação matemática.
///
/// Contém os dados de uma operação realizada:
/// - Expressão (ex: "5 + 3")
/// - Valor resultante
/// - Timestamp de quando foi calculada
///
/// Imutável - uma vez criada, não pode ser modificada.
library calculation_result;

/// Dados de um cálculo realizado.
///
/// Usada para:
/// - Armazenar no histórico
/// - Exibir na lista de operações
/// - Análise de padrões de uso
///
/// Exemplo:
/// ```dart
/// final result = CalculationResult(
///   expression: '15 / 3',
///   value: 5.0,
///   createdAt: DateTime.now(),
/// );
/// print('${result.expression} = ${result.value}');  // "15 / 3 = 5.0"
/// ```
class CalculationResult {
  /// Cria um CalculationResult imutável.
  ///
  /// Parâmetros:
  /// - [expression]: expressão matemática (ex: "5 + 3" ou "5 + 3 =")
  /// - [value]: resultado numérico da operação
  /// - [createdAt]: data e hora em que foi calculado
  const CalculationResult({
    required this.expression,
    required this.value,
    required this.createdAt,
  });

  /// Expressão matemática que foi calculada.
  /// Exemplo: "5 + 3 =" ou "10 / 2"
  final String expression;

  /// Valor resultante da operação.
  /// Exemplo: 8.0 para "5 + 3"
  final double value;

  /// Data e hora em que o cálculo foi realizado.
  /// Útil para ordenar histórico e exibir "timestamp relativo" (ex: "há 2 min")
  final DateTime createdAt;
}
