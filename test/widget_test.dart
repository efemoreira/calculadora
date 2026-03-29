import 'package:flutter_calculator_app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('deve inicializar a calculadora sem erros', (
    WidgetTester tester,
  ) async {
    // Pumpwidget com MaterialApp - verifica que não há exceção não capturada
    await tester.pumpWidget(const CalculatorApp());

    // Aguarda a UI renderizar completamente
    await tester.pumpAndSettle();

    // Se chegou aqui, significa que:
    // 1. A app foi criada sem exceções
    // 2. Os widgets foram renderizados corretamente
    // 3. O controller foi injetado corretamente
    expect(true, true); // Teste passou
  });
}
