/// Padrão Result - Tratamento de sucesso/falha sem exceções.
///
/// Implementa uma abordagem funcional para lidar com operações que podem
/// falhar, retornando um objeto que representa sucesso ou falha.
///
/// Vantagens:
/// - Não usa exceções (mais previsível)
/// - Type-safe (sabe qual tipo é retornado em sucesso)
/// - Força lidar com ambos os casos (sucesso e falha)
library result;

/// Classe selada que representa o resultado de uma operação.
///
/// Pode ser:
/// - [Success<T>]: Operação bem-sucedida com um valor do tipo T
/// - [FailureResult<T>]: Operação falhou com uma mensagem de erro
///
/// Exemplo de uso:
/// ```dart
/// Result<double> result = calculateUseCase.call(5, '+', 3);
/// result.when(
///   success: (value) => print('Resultado: $value'),
///   failure: (message) => print('Erro: $message'),
/// );
/// ```
sealed class Result<T> {
  /// Cria um Result.
  const Result();

  /// Padrão matching para processar sucesso ou falha.
  ///
  /// Permite processar ambos os casos de forma segura e forçada.
  /// É um padrão funcional comum em linguagens como Rust, Haskell, etc.
  ///
  /// Tipo:
  /// - [success]: Função chamada se resultado é bem-sucedido, recebe o valor
  /// - [failure]: Função chamada se resultado é erro, recebe a mensagem
  ///
  /// Retorna:
  /// - O tipo genérico [R] que ambas as funções retornam
  ///
  /// Exemplo:
  /// ```dart
  /// final message = result.when(
  ///   success: (value) => 'Total: $value',
  ///   failure: (error) => 'Erro: $error',
  /// );
  /// ```
  R when<R>({
    required R Function(T value) success,
    required R Function(String message) failure,
  });
}

/// Representa um resultado de sucesso com um valor.
///
/// Contendo:
/// - [value]: O valor retornado pela operação
///
/// Exemplo:
/// ```dart
/// Result<double> success = Success(8.0);
/// ```
class Success<T> extends Result<T> {
  /// Cria um Success com um valor.
  const Success(this.value);

  /// O valor calculado/obtido da operação bem-sucedida.
  final T value;

  @override
  R when<R>({
    required R Function(T value) success,
    required R Function(String message) failure,
  }) {
    // Success chama a função de sucesso com o valor
    return success(value);
  }
}

/// Representa um resultado de falha com mensagem de erro.
///
/// Contendo:
/// - [message]: Descrição do erro ocorrido
///
/// Exemplo:
/// ```dart
/// Result<double> failure = FailureResult('Não é possível dividir por zero.');
/// ```
class FailureResult<T> extends Result<T> {
  /// Cria um FailureResult com uma mensagem de erro.
  const FailureResult(this.message);

  /// Mensagem descrevendo o erro da operação.
  final String message;

  @override
  R when<R>({
    required R Function(T value) success,
    required R Function(String message) failure,
  }) {
    // FailureResult chama a função de falha com a mensagem
    return failure(message);
  }
}
