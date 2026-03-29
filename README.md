# Flutter Calculator App

Aplicativo Flutter de calculadora com clean architecture e historico em sessao.

## Requisitos

- Flutter 3.38+

## Rodando localmente

1. flutter pub get
2. flutter test
3. flutter run

## Estrutura

- lib/core: contratos e utilitarios base
- lib/features/calculator/domain: entidades, repositorios e casos de uso
- lib/features/calculator/data: implementacoes concretas
- lib/features/calculator/presentation: UI e controller

## MVP implementado

- Operacoes: +, -, *, /
- Validacao de entrada
- Tratamento de divisao por zero
- Historico em memoria na sessao
- Testes unitarios e de widget
