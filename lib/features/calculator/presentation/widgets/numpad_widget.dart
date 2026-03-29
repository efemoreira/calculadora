/// Widget que exibe o teclado numérico da calculadora em formato de grid.
///
/// Organiza os botões em uma grade 4x5 com:
/// - Números 0-9
/// - Operações (+, -, *, /)
/// - Botões especiais (AC para limpar, = para calcular, ← para deletar)
library numpad_widget;

import 'package:flutter/material.dart';

/// Tipo de botão no numpad (para estilização diferenciada).
enum NumPadButtonType {
  /// Número (0-9).
  number,

  /// Operação matemática (+, -, *, /).
  operation,

  /// Botão especial (AC, =, ←).
  special,
}

/// Callback chamado quando um botão é pressionado.
/// Recebe o valor (número, operador ou comando especial).
typedef OnButtonPressed = void Function(String value);

/// Widget de teclado numérico em formato grid.
///
/// Exemplo de uso:
/// ```dart
/// NumPadWidget(
///   onButtonPressed: (value) {
///     setState(() {
///       if (value == 'AC') {
///         // limpar
///       } else if (value == '=') {
///         // calcular
///       }
///     });
///   },
/// )
/// ```
class NumPadWidget extends StatelessWidget {
  /// Cria um NumPadWidget.
  const NumPadWidget({super.key, required this.onButtonPressed});

  /// Callback chamado quando qualquer botão é pressionado.
  final OnButtonPressed onButtonPressed;

  /// Define o layout do teclado numérico.
  /// Retorna uma lista de linhas, cada linha contém uma lista de botões.
  static const List<List<(String label, NumPadButtonType type)>> layout = [
    [
      ('AC', NumPadButtonType.special),
      ('←', NumPadButtonType.special),
      ('/', NumPadButtonType.operation),
      ('*', NumPadButtonType.operation),
    ],
    [
      ('7', NumPadButtonType.number),
      ('8', NumPadButtonType.number),
      ('9', NumPadButtonType.number),
      ('-', NumPadButtonType.operation),
    ],
    [
      ('4', NumPadButtonType.number),
      ('5', NumPadButtonType.number),
      ('6', NumPadButtonType.number),
      ('+', NumPadButtonType.operation),
    ],
    [
      ('1', NumPadButtonType.number),
      ('2', NumPadButtonType.number),
      ('3', NumPadButtonType.number),
      ('=', NumPadButtonType.special),
    ],
    [('0', NumPadButtonType.number), (',', NumPadButtonType.number)],
  ];

  /// Retorna a cor de fundo baseada no tipo de botão.
  Color _getButtonColor(BuildContext context, NumPadButtonType type) {
    return switch (type) {
      NumPadButtonType.number => Theme.of(context).colorScheme.surface,
      NumPadButtonType.operation => Theme.of(context).colorScheme.secondary,
      NumPadButtonType.special => Theme.of(context).colorScheme.primary,
    };
  }

  /// Retorna a cor do texto baseada no tipo de botão.
  Color _getTextColor(BuildContext context, NumPadButtonType type) {
    return switch (type) {
      NumPadButtonType.number => Theme.of(context).colorScheme.onSurface,
      NumPadButtonType.operation => Theme.of(context).colorScheme.onSecondary,
      NumPadButtonType.special => Theme.of(context).colorScheme.onPrimary,
    };
  }

  /// Cria um botão do teclado numérico.
  ///
  /// Styled de acordo com o [type] e responsivo ao toque.
  Widget _buildButton(
    BuildContext context,
    String label,
    NumPadButtonType type, {
    bool fullWidth = false,
  }) {
    return Expanded(
      flex: fullWidth ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _getButtonColor(context, type),
            foregroundColor: _getTextColor(context, type),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
          ),
          onPressed: () => onButtonPressed(label),
          child: Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          children: [
            // Linhas 1-4: layout normal (4 botões por linha)
            ...layout.sublist(0, 4).map((row) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    for (final (label, type) in row)
                      _buildButton(context, label, type),
                  ],
                ),
              );
            }),
            // Linha 5: layout especial (0 ocupa 2 espaços, vírgula ocupa 1)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  _buildButton(
                    context,
                    '0',
                    NumPadButtonType.number,
                    fullWidth: true,
                  ),
                  _buildButton(context, ',', NumPadButtonType.number),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
