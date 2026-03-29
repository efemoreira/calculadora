/// Widget que exibe o histórico de operações realizadas.
///
/// Mostra uma lista de operações executadas com:
/// - Expressão matemática (ex: "5 + 3 =")
/// - Valor resultado
/// - Data e hora da operação
library history_list;

import 'package:flutter/material.dart';
import 'package:flutter_calculator_app/features/calculator/domain/entities/calculation_result.dart';

/// Widget que exibe uma lista de CalculationResult em ordem reversa (top = mais recente).
///
/// Exemplos de uso:
/// ```dart
/// HistoryList(
///   items: [
///     CalculationResult(expression: "5 + 3 =", value: 8.0, createdAt: now),
///     CalculationResult(expression: "10 / 2 =", value: 5.0, createdAt: now - 1min),
///   ],
///   isLoading: false,
/// )
/// ```
class HistoryList extends StatelessWidget {
  /// Cria um HistoryList.
  ///
  /// Requer:
  /// - [items]: lista de operações a exibir (em ordem reversa, top = mais recente)
  /// - [isLoading]: flag para mostrar loading state (opcional)
  const HistoryList({super.key, required this.items, this.isLoading = false});

  /// Lista de operações realizadas.
  /// Primeira posição (index 0) é a mais recente.
  final List<CalculationResult> items;

  /// Indica se há uma operação sendo calculada.
  /// Quando true, mostra um indicador de loading.
  final bool isLoading;

  /// Formata um número removendo zeros desnecessários.
  ///
  /// Exemplos:
  /// - 8.0 -> "8"
  /// - 3.14 -> "3.14"
  /// - 3.140 -> "3.14"
  static String _format(double value) {
    // Se é um número inteiro, remove os decimais
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    // Caso contrário, limpa zeros à direita
    String stringValue = value.toString();

    // Se tem ponto decimal, remove zeros à direita e ponto final se necessário
    if (stringValue.contains('.')) {
      // Remove zeros à direita
      stringValue = stringValue.replaceAll(RegExp(r'0+$'), '');
      // Remove ponto decimal se virou inteiro
      stringValue = stringValue.replaceAll(RegExp(r'\.$'), '');
    }

    return stringValue;
  }

  @override
  Widget build(BuildContext context) {
    /// Se não há histórico, mostra mensagem vazia
    if (items.isEmpty) {
      return Center(
        child: Text(
          'Nenhuma operação realizada\nnesta sessão.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    /// Cria uma lista de cards mostrando histórico
    /// Cada card exibe: expressão, resultado, data/hora
    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final item = items[index];

        // Formata o tempo relativo (ex: "2 minutos atrás")
        final now = DateTime.now();
        final diff = now.difference(item.createdAt);

        String timeAgo;
        if (diff.inSeconds < 60) {
          timeAgo = 'agora';
        } else if (diff.inMinutes < 60) {
          timeAgo = 'há ${diff.inMinutes} min';
        } else if (diff.inHours < 24) {
          timeAgo = 'há ${diff.inHours} h';
        } else {
          timeAgo = item.createdAt.toString().split('.')[0];
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Expressão (ex: "5 + 3 =")
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.expression,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          timeAgo,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  // Resultado (ex: "8")
                  Text(
                    _format(item.value),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
