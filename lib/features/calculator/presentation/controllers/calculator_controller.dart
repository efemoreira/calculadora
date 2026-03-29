/// Gerencia o estado e lógica da calculadora.
///
/// Responsável por:
/// - Acumular números digitados
/// - Gerenciar operações e operandos
/// - Executar cálculos através dos use cases
/// - Notificar alterações de estado para a UI
library calculator_controller;

import 'package:flutter/foundation.dart';
import 'package:flutter_calculator_app/features/calculator/domain/entities/calculation_result.dart';
import 'package:flutter_calculator_app/features/calculator/domain/usecases/add_history_entry_usecase.dart';
import 'package:flutter_calculator_app/features/calculator/domain/usecases/calculate_operation_usecase.dart';
import 'package:flutter_calculator_app/features/calculator/domain/usecases/clear_history_usecase.dart';
import 'package:flutter_calculator_app/features/calculator/domain/usecases/get_history_usecase.dart';
import 'package:flutter_calculator_app/features/calculator/presentation/state/calculator_state.dart';

/// Controller que gerencia toda a lógica de uma calculadora.
///
/// Implementa o padrão MVVM com ChangeNotifier para reatividade.
/// Trabalha com use cases do domain layer para realizar cálculos.
///
/// Estados gerenciados:
/// - [_displayValue]: número sendo exibido no display
/// - [_previousValue]: primeiro operando
/// - [_operator]: operação selecionada (+, -, *, /)
/// - [_state]: estado geral (resultado, erro, histórico, loading)
class CalculatorController extends ChangeNotifier {
  /// Cria um CalculatorController com os use cases necessários.
  ///
  /// Requer:
  /// - [calculateOperation]: executa operações matemáticas
  /// - [addHistoryEntry]: adiciona resultado ao histórico
  /// - [getHistory]: carrega histórico de operações
  /// - [clearHistory]: limpa todo o histórico
  CalculatorController({
    required CalculateOperationUseCase calculateOperation,
    required AddHistoryEntryUseCase addHistoryEntry,
    required GetHistoryUseCase getHistory,
    required ClearHistoryUseCase clearHistory,
  }) : _calculateOperation = calculateOperation,
       _addHistoryEntry = addHistoryEntry,
       _getHistory = getHistory,
       _clearHistory = clearHistory;

  // Dependencies (injeção de dependência)
  final CalculateOperationUseCase _calculateOperation;
  final AddHistoryEntryUseCase _addHistoryEntry;
  final GetHistoryUseCase _getHistory;
  final ClearHistoryUseCase _clearHistory;

  // Estado interno da calculadora
  /// Valor exibido no display principal (número sendo digitado ou resultado).
  String _displayValue = '0';

  /// Primeiro operando da operação (antes do operador).
  String _previousValue = '';

  /// Operador selecionado (+, -, *, /).
  String? _operator;

  /// Flag para saber se deve iniciar um novo número no próximo dígito.
  /// Verdadeiro após operador ou =, para não concatenar ao número anterior.
  bool _startNewNumber = true;

  /// Estado geral da calculadora (resultado, erro, histórico, etc).
  CalculatorState _state = const CalculatorState();
  CalculatorState get state => _state;

  /// Carrega o histórico de operações anteriores.
  void loadHistory() {
    _state = _state.copyWith(history: _getHistory.call());
    notifyListeners();
  }

  /// Limpa o histórico de operações.
  void clearSessionHistory() {
    _clearHistory.call();
    _state = _state.copyWith(history: const [], errorText: '', resultText: '');
    notifyListeners();
  }

  /// Processa o clique em um botão do teclado numérico.
  ///
  /// Parâmetros:
  /// - [value]: valor do botão ('0'-'9', ',', '+', '-', '*', '/', '=', 'AC', '←')
  ///
  /// Exemplos:
  /// ```
  /// handleButtonPress('5');    // Adiciona 5 ao display
  /// handleButtonPress('+');    // Prepara para próximo operando
  /// handleButtonPress('=');    // Calcula o resultado
  /// handleButtonPress('AC');   // Limpa tudo
  /// handleButtonPress('←');    // Remove último dígito
  /// ```
  void handleButtonPress(String value) {
    if (value == 'AC') {
      // Limpa tudo e volta ao estado inicial
      _clear();
    } else if (value == '←') {
      // Remove o último dígito
      _deleteLastDigit();
    } else if (value == '=') {
      // Calcula o resultado da operação
      _calculate();
    } else if (['+', '-', '*', '/'].contains(value)) {
      // Define um novo operador
      _setOperator(value);
    } else if (value == ',') {
      // Adiciona vírgula (separador decimal)
      _addDecimal();
    } else {
      // Adiciona um dígito (0-9)
      _addDigit(value);
    }

    notifyListeners();
  }

  /// Adiciona um dígito ao número sendo digitado.
  ///
  /// Se um novo número deve começar (após operador ou =),
  /// substitui o display. Caso contrário, concatena ao número.
  void _addDigit(String digit) {
    if (_startNewNumber) {
      _displayValue = digit;
      _startNewNumber = false;
    } else {
      // Evita múltiplos zeros à esquerda (ex: "00" invés de apenas "0")
      if (_displayValue == '0' && digit != ',') {
        _displayValue = digit;
      } else {
        _displayValue += digit;
      }
    }
  }

  /// Adiciona um separador decimal (vírgula) ao número.
  ///
  /// Garante que não haja múltiplas vírgulas no mesmo número.
  /// Se iniciando novo número, começa com "0,".
  void _addDecimal() {
    if (_startNewNumber) {
      _displayValue = '0,';
      _startNewNumber = false;
    } else if (!_displayValue.contains(',')) {
      // Só adiciona vírgula se ainda não houver uma
      _displayValue += ',';
    }
  }

  /// Remove o último dígito do número sendo digitado.
  ///
  /// Se ficar vazio, mostra '0'.
  void _deleteLastDigit() {
    if (_displayValue.length > 1) {
      _displayValue = _displayValue.substring(0, _displayValue.length - 1);
    } else {
      _displayValue = '0';
    }
  }

  /// Limpa todos os valores e volta ao estado inicial.
  void _clear() {
    _displayValue = '0';
    _previousValue = '';
    _operator = null;
    _startNewNumber = true;
    _state = _state.copyWith(errorText: '', resultText: '');
  }

  /// Define um novo operador ou calcula antes de trocar.
  ///
  /// Se já há um operador definido, calcula o resultado intermediário
  /// antes de definir o novo operador (permite operações em cadeia).
  void _setOperator(String newOperator) {
    // Se já tem uma operação pendente, calcula antes de trocar operador
    if (_operator != null && !_startNewNumber) {
      _calculate();
    }

    _previousValue = _displayValue;
    _operator = newOperator;
    _startNewNumber = true;
  }

  /// Executa o cálculo da operação pendente.
  ///
  /// Usa o use case [_calculateOperation] para executar a operação.
  /// Em caso de sucesso:
  /// - Adiciona ao histórico
  /// - Mostra resultado no display
  /// - Marca para iniciar novo número
  ///
  /// Em caso de erro:
  /// - Mostra mensagem de erro
  void _calculate() {
    if (_operator == null) return;

    // Converte strings em números (substitui vírgula por ponto para parsing)
    final left = double.tryParse(_previousValue.replaceAll(',', '.'));
    final right = double.tryParse(_displayValue.replaceAll(',', '.'));

    if (left == null || right == null) {
      _state = _state.copyWith(errorText: 'Erro na entrada de números.');
      return;
    }

    _state = _state.copyWith(isLoading: true, errorText: '');

    // Executa a operação através do use case
    final result = _calculateOperation.call(
      left: left,
      operator: _operator!,
      right: right,
    );

    // Pattern matching no resultado (sucesso ou falha)
    result.when(
      success: (value) {
        // Formata a expressão para o histórico (ex: "5 + 3 =")
        final expression =
            '${_formatNumber(left)} $_operator ${_formatNumber(right)} =';
        final item = CalculationResult(
          expression: expression,
          value: value,
          createdAt: DateTime.now(),
        );

        // Adiciona ao histórico
        _addHistoryEntry.call(item);

        // Atualiza o estado: resultado no display, pronto para novo número
        _displayValue = _formatNumber(value);
        _previousValue = '';
        _operator = null;
        _startNewNumber = true;

        _state = _state.copyWith(
          isLoading: false,
          errorText: '',
          resultText: _formatNumber(value),
          history: _getHistory.call(),
        );
      },
      failure: (failure) {
        // Em caso de erro (ex: divisão por zero), mostra mensagem
        _state = _state.copyWith(isLoading: false, errorText: failure);
      },
    );
  }

  /// Formata um número removendo zeros desnecessários.
  ///
  /// Exemplos:
  /// - 5.0 -> "5"
  /// - 3.14159 -> "3.14159"
  /// - 1000000.0 -> "1000000"
  static String _formatNumber(double value) {
    // Se é um número inteiro, remove os decimais
    if (value == value.toInt()) {
      return value.toInt().toString();
    }
    // Caso contrário, retorna com todos os decimais
    return value.toString();
  }

  /// Retorna o valor a ser exibido no display principal.
  String get displayValue => _displayValue;

  /// Retorna o operador e operando anterior para exibição.
  ///
  /// Exemplo: se primeiro número é 5 e operador é +, retorna "5 +"
  /// Útil para mostrar a expressão em progresso no display.
  String getPreviousDisplay() {
    if (_operator == null) return '';
    return '$_previousValue $_operator';
  }
}
