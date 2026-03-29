/// Hierarquia de tipos de falha/erro da aplicação.
///
/// Define diferentes categorias de erros que podem ocorrer,
/// permitindo tratamento específico por tipo de falha.
///
/// Tipos disponíveis:
/// - [ValidationFailure]: Erro de validação de entrada (ex: número inválido)
/// - [MathFailure]: Erro matemático (ex: divisão por zero)
library failures;

/// Classe base abstrata para representar falhas na aplicação.
///
/// Todas as falhas herdam de Failure e possuem uma mensagem descritiva.
/// Centraliza o tratamento de erros de forma type-safe.
///
/// Exemplo:
/// ```dart
/// if (failure is ValidationFailure) {
///   print('Erro de validação: ${failure.message}');
/// } else if (failure is MathFailure) {
///   print('Erro matemático: ${failure.message}');
/// }
/// ```
abstract class Failure {
  /// Cria uma Failure com uma mensagem.
  const Failure(this.message);

  /// Mensagem descrevendo o erro.
  final String message;

  /// Retorna a mensagem do erro quando convertido para string.
  @override
  String toString() => message;
}

/// Falha por erro de validação de entrada.
///
/// Usado quando:
/// - Números inválidos são fornecidos
/// - Formato incorreto de entrada
/// - Valores fora do intervalo aceito
///
/// Exemplo:
/// ```dart
/// throw ValidationFailure('Digite um número válido.');
/// ```
class ValidationFailure extends Failure {
  /// Cria uma ValidationFailure.
  const ValidationFailure(super.message);
}

/// Falha por erro em operação matemática.
///
/// Usado quando:
/// - Divisão por zero
/// - Operação não válida
/// - Overflow ou resultados inválidos
///
/// Exemplo:
/// ```dart
/// throw MathFailure('Não é possível dividir por zero.');
/// ```
class MathFailure extends Failure {
  /// Cria uma MathFailure.
  const MathFailure(super.message);
}
