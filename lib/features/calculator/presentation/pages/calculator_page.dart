/// Página principal da calculadora com interface moderna.
///
/// Apresenta:
/// - Display mostrando número atual e operação em progresso
/// - Grid numérico (0-9, operações, AC, =, ←)
/// - Histórico de operações realizadas
///
/// Usa arquitetura limpa com CalculatorController para gerenciar toda lógica.
library calculator_page;

import 'package:flutter/material.dart';
import 'package:flutter_calculator_app/features/calculator/presentation/controllers/calculator_controller.dart';
import 'package:flutter_calculator_app/features/calculator/presentation/widgets/calculator_display.dart';
import 'package:flutter_calculator_app/features/calculator/presentation/widgets/history_list.dart';
import 'package:flutter_calculator_app/features/calculator/presentation/widgets/numpad_widget.dart';

/// Página da calculadora - widget stateful.
///
/// Responsável por:
/// - Exibir o display da calculadora
/// - Gerenciar o numpad (teclado numérico)
/// - Mostrar o histórico de operações
/// - Coordenar interações do usuário com o controller
class CalculatorPage extends StatefulWidget {
  /// Cria uma CalculatorPage.
  ///
  /// Requer um [controller] já injetado com todas as dependências.
  const CalculatorPage({super.key, required this.controller});

  /// Controller que gerencia a lógica da calculadora.
  final CalculatorController controller;

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

/// Estado interno da CalculatorPage.
class _CalculatorPageState extends State<CalculatorPage>
    with SingleTickerProviderStateMixin {
  /// TabController para alternar entre display e histórico.
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Carrega o histórico de operações anteriores quando a página inicia
    widget.controller.loadHistory();

    // Inicializa tab controller (para abas de display/histórico)
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // Limpa recursos quando a página é destruída
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AnimatedBuilder permite que a UI reaja a mudanças no controller
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final state = widget.controller.state;

        return Scaffold(
          appBar: AppBar(
            /// Título da aplicação
            title: const Text(
              '🧮 Calculadora',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            elevation: 4,
            centerTitle: true,
          ),
          body: Column(
            children: [
              // ========== DISPLAY ==========
              /// Display mostra o número atual e a operação em progresso
              Padding(
                padding: const EdgeInsets.all(16),
                child: CalculatorDisplay(
                  currentValue: widget.controller.displayValue,
                  previousValue: widget.controller.getPreviousDisplay(),
                ),
              ),

              // ========== MENSAGEM DE ERRO ==========
              /// Mostra erro se houver (ex: divisão por zero)
              if (state.errorText.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      state.errorText,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 8),

              // ========== NUMPAD (TECLADO NUMÉRICO) ==========
              /// Grid com números 0-9 e operações (+, -, *, /)
              Expanded(
                flex: 3,
                child: NumPadWidget(
                  onButtonPressed: (value) {
                    // Passa o clique do botão para o controller processar
                    widget.controller.handleButtonPress(value);
                  },
                ),
              ),

              // ========== HISTÓRICO ==========
              /// Mostra todas as operações realizadas (em ordem reversa)
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header do histórico
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '📋 Histórico',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          // Botão para limpar histórico
                          if (state.history.isNotEmpty)
                            TextButton.icon(
                              onPressed: widget.controller.clearSessionHistory,
                              icon: const Icon(Icons.delete_outline, size: 18),
                              label: const Text('Limpar'),
                              style: TextButton.styleFrom(
                                foregroundColor: Theme.of(
                                  context,
                                ).colorScheme.error,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Lista de operações do histórico
                    Expanded(
                      child: HistoryList(
                        items: state.history,
                        isLoading: state.isLoading,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/*
═══════════════════════════════════════════════════════════════════════════════
DOCUMENTAÇÃO DA ARQUITETURA
═══════════════════════════════════════════════════════════════════════════════

## Fluxo de Dados

1. Usuário clica em um botão do NumPad
   ↓
2. CalculatorPage chama controller.handleButtonPress(value)
   ↓
3. CalculatorController processa o valor:
   - Se número: adiciona ao display acumulado
   - Se operador: armazena e aguarda próximo número
   - Se =: executa cálculo através do use case
   ↓
4. Use case (CalculateOperationUseCase) executa operação matemática
   ↓
5. Resultado é adicionado ao histórico via repositório
   ↓
6. Controller notifica listeners (setState implícito via AnimatedBuilder)
   ↓
7. UI re-renderiza com novo estado

## Camadas da Arquitetura Limpa

┌─────────────────────────────────────────────────────────┐
│  PRESENTATION LAYER (lib/features/calculator/presentation/)
│  - CalculatorPage: UI
│  - CalculatorController: Estado e Lógica
│  - CalculatorDisplay: Display do resultado
│  - NumPadWidget: Teclado numérico
│  - HistoryList: Lista de operações
└─────────────────────────────────────────────────────────┘
                           ↑
       ┌───────────────────┴───────────────────┐
       ↓                                       ↓
┌──────────────────┐             ┌──────────────────┐
│  DOMAIN LAYER    │             │  DATA LAYER      │
│  (Entities)      │             │  (Repositories)  │
│  (UseCases)      │             │                  │
│  (Repositories)  │             │  - CalculatorRep│
│                  │             │    ositoryImpl   │
│ - Calculate      │             │  - HistoryRepo  │
│ - GetHistory     │             │    itory        │
│ - AddHistory     │             │    MemoryImpl    │
│ - ClearHistory   │             │                  │
└──────────────────┘             └──────────────────┘

## Padrões Utilizados

- **MVVM**: Model-View-ViewModel com ChangeNotifier
- **Repository Pattern**: Abstração de acesso a dados
- **Use Cases**: Lógica de negócio isolada
- **Dependency Injection**: Injeção de dependências no constructor
- **Result Pattern**: Resultado genérico para sucesso/falha

*/
