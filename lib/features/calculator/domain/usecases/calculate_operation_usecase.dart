/// Use case para executar operações matemáticas.
///
/// Responsável por encapsular a lógica de negócio de cálculos,
/// delegando a implementação concreta para o repository.
///
/// Exemplos:
/// ```dart
/// final useCase = CalculateOperationUseCase(repository);
/// final result = useCase(left: 5, operator: '+', right: 3);
/// result.when(
///   success: (value) => print('Resultado: $value'),
///   failure: (error) => print('Erro: ${error.message}'),
/// );
/// ```
library calculate_operation_usecase;

import 'package:flutter_calculator_app/core/result/result.dart';
import 'package:flutter_calculator_app/features/calculator/domain/repositories/calculator_repository.dart';

/// Use case que executa uma operação matemática.
///
/// Recebe dois operandos e um operador, e retorna o resultado
/// ou um erro (ex: divisão por zero).
///
/// Este padrão (usar case) é uma boa prática de Clean Architecture
/// pois separa a lógica de negócio da apresentação e dados.
class CalculateOperationUseCase {
  /// Cria um CalculateOperationUseCase.
  ///
  /// Requer um [CalculatorRepository] injetado.
  /// Este repository contém a implementação concreta do cálculo.
  const CalculateOperationUseCase(this._calculatorRepository);

  /// Repository que fornece a implementação do cálculo.
  final CalculatorRepository _calculatorRepository;

  /// Executa uma operação matemática.
  ///
  /// Parâmetros:
  /// - [left]: primeiro operando
  /// - [operator]: operação a executar ('+', '-', '*', '/')
  /// - [right]: segundo operando
  ///
  /// Retorna:
  /// - [Result<double>]: sucesso com valor calculado ou falha com mensagem de erro
  ///
  /// Exemplos de uso:
  /// ```
  /// // Soma
  /// call(left: 5, operator: '+', right: 3)  // Result.success(8.0)
  ///
  /// // Divisão por zero
  /// call(left: 5, operator: '/', right: 0)  // Result.failure(MathFailure)
  ///
  /// // Subtração
  /// call(left: 10, operator: '-', right: 3)  // Result.success(7.0)
  /// ```
  Result<double> call({
    required double left,
    required String operator,
    required double right,
  }) {
    // Delega a execução ao repository
    return _calculatorRepository.calculate(left, operator, right);
  }
}
