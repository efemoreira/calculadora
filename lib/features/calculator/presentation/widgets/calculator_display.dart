/// Widget que exibe o resultado da calculadora.
///
/// Responsável por mostrar:
/// - O resultado principal (número ou resultado da operação)
/// - O histórico de operações (ex: "5 + 3" antes do "=")
/// - Formatação clara dos números com separadores de milhar
library calculator_display;

import 'package:flutter/material.dart';

/// Widget de exibição da calculadora.
///
/// Apresenta dois níveis de informação:
/// 1. [previousValue]: mostra a operação anterior (ex: "5 +")
/// 2. [currentValue]: mostra o número atual ou resultado
class CalculatorDisplay extends StatelessWidget {
  /// Cria um CalculatorDisplay.
  const CalculatorDisplay({
    super.key,
    required this.currentValue,
    this.previousValue = '',
  });

  /// Valor que está sendo exibido no display principal.
  /// Pode ser um número sendo digitado ou resultado de uma operação.
  final String currentValue;

  /// Valor anterior com operador (ex: "5 +").
  /// Ajuda o usuário a entender qual operação está em progresso.
  final String previousValue;

  /// Formata números grandes com separadores de milhar.
  ///
  /// Exemplo: 1000000 -> "1.000.000"
  String _formatDisplay(String value) {
    if (value.isEmpty) return '0';
    final parts = value.split('.');
    final intPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';

    // Adiciona separadores de milhar ao inteiro
    final buffer = StringBuffer();
    for (var i = 0; i < intPart.length; i++) {
      if (i > 0 && (intPart.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(intPart[i]);
    }

    if (decimalPart.isNotEmpty) {
      buffer.write(',');
      buffer.write(decimalPart);
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Mostra a operação anterior (ex: "5 +")
          if (previousValue.isNotEmpty)
            Text(
              previousValue,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 8),
          // Mostra o número atual ou resultado
          Text(
            _formatDisplay(currentValue),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
