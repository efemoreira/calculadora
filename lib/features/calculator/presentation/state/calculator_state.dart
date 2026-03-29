import 'package:flutter_calculator_app/features/calculator/domain/entities/calculation_result.dart';

class CalculatorState {
  const CalculatorState({
    this.resultText = '',
    this.errorText = '',
    this.history = const [],
    this.isLoading = false,
  });

  final String resultText;
  final String errorText;
  final List<CalculationResult> history;
  final bool isLoading;

  CalculatorState copyWith({
    String? resultText,
    String? errorText,
    List<CalculationResult>? history,
    bool? isLoading,
  }) {
    return CalculatorState(
      resultText: resultText ?? this.resultText,
      errorText: errorText ?? this.errorText,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
