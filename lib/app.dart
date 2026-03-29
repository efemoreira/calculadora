import 'package:flutter/material.dart';
import 'package:flutter_calculator_app/features/calculator/data/repositories/calculator_repository_impl.dart';
import 'package:flutter_calculator_app/features/calculator/data/repositories/history_repository_memory_impl.dart';
import 'package:flutter_calculator_app/features/calculator/domain/usecases/add_history_entry_usecase.dart';
import 'package:flutter_calculator_app/features/calculator/domain/usecases/calculate_operation_usecase.dart';
import 'package:flutter_calculator_app/features/calculator/domain/usecases/clear_history_usecase.dart';
import 'package:flutter_calculator_app/features/calculator/domain/usecases/get_history_usecase.dart';
import 'package:flutter_calculator_app/features/calculator/presentation/controllers/calculator_controller.dart';
import 'package:flutter_calculator_app/features/calculator/presentation/pages/calculator_page.dart';

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final calculatorRepository = CalculatorRepositoryImpl();
    final historyRepository = HistoryRepositoryMemoryImpl();

    final controller = CalculatorController(
      calculateOperation: CalculateOperationUseCase(calculatorRepository),
      addHistoryEntry: AddHistoryEntryUseCase(historyRepository),
      getHistory: GetHistoryUseCase(historyRepository),
      clearHistory: ClearHistoryUseCase(historyRepository),
    );

    return MaterialApp(
      title: 'Flutter Calculator App',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: CalculatorPage(controller: controller),
    );
  }
}
