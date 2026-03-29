/// Implementação concreta do repositório de cálculos.
///
/// Esta classe implementa as operações matemáticas:
/// - Adição (+)
/// - Subtração (-)
/// - Multiplicação (*)
/// - Divisão (/)
///
/// Valida casos especiais como divisão por zero.
library calculator_repository_impl;

import 'package:flutter_calculator_app/core/result/result.dart';
import 'package:flutter_calculator_app/features/calculator/domain/repositories/calculator_repository.dart';

/// Implementação do CalculatorRepository.
///
/// Responsável por executar operações matemáticas e retornar resultados
/// ou erros através do padrão Result (sem usar exceções).
///
/// Suporta:
/// - Soma: 5 + 3 = 8
/// - Subtração: 10 - 3 = 7
/// - Multiplicação: 4 * 5 = 20
/// - Divisão: 20 / 4 = 5 (ou erro se divisor for zero)
class CalculatorRepositoryImpl implements CalculatorRepository {
  /// Executa uma operação matemática.
  ///
  /// Parâmetros:
  /// - [left]: primeiro operando (número à esquerda)
  /// - [operator]: operação a executar ('+', '-', '*', '/')
  /// - [right]: segundo operando (número à direita)
  ///
  /// Retorna:
  /// - [Result<double>.success]: resultado do cálculo
  /// - [Result<double>.failure]: mensagem de erro (ex: divisão por zero)
  ///
  /// Exemplos:
  /// ```dart
  /// calculate(5, '+', 3)      // Success(8.0)
  /// calculate(10, '-', 4)     // Success(6.0)
  /// calculate(3, '*', 7)      // Success(21.0)
  /// calculate(20, '/', 4)     // Success(5.0)
  /// calculate(5, '/', 0)      // FailureResult('Não é possível dividir por zero.')
  /// calculate(5, '%', 3)      // FailureResult('Operador inválido.')
  /// ```
  @override
  Result<double> calculate(double left, String operator, double right) {
    // Pattern matching sobre o operador
    switch (operator) {
      case '+':
        // Adição simples
        return Success(left + right);

      case '-':
        // Subtração simples
        return Success(left - right);

      case '*':
        // Multiplicação simples
        return Success(left * right);

      case '/':
        // Divisão com validação de divisor zero
        if (right == 0) {
          // Retorna erro se tentando dividir por zero
          return const FailureResult<double>(
            'Não é possível dividir por zero.',
          );
        }
        return Success(left / right);

      default:
        // Operador desconhecido
        return const FailureResult<double>('Operador inválido.');
    }
  }
}
