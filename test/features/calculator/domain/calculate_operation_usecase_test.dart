import 'package:flutter_calculator_app/core/result/result.dart';
import 'package:flutter_calculator_app/features/calculator/data/repositories/calculator_repository_impl.dart';
import 'package:flutter_calculator_app/features/calculator/domain/usecases/calculate_operation_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CalculateOperationUseCase useCase;

  setUp(() {
    useCase = CalculateOperationUseCase(CalculatorRepositoryImpl());
  });

  test('deve retornar soma correta', () {
    final result = useCase.call(left: 2, operator: '+', right: 3);
    expect(result, isA<Success<double>>());
    result.when(
      success: (value) => expect(value, 5),
      failure: (_) => fail('Nao deveria falhar'),
    );
  });

  test('deve falhar em divisao por zero', () {
    final result = useCase.call(left: 10, operator: '/', right: 0);
    expect(result, isA<FailureResult<double>>());
    result.when(
      success: (_) => fail('Nao deveria ter sucesso'),
      failure: (message) => expect(message, contains('zero')),
    );
  });
}
