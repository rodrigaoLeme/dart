import 'dart:io';

import 'package:imc/models/pessoa.dart';

void main(List<String> arguments) {
  try {
    stdout.write("Informe o nome da pessoa: ");
    String nome = stdin.readLineSync() ?? "";

    stdout.write("Informe o peso da pessoa (em kg): ");
    double peso = double.parse(stdin.readLineSync() ?? "0");

    stdout.write("Informe a altura da pessoa (em metros): ");
    double altura = double.parse(stdin.readLineSync() ?? "0");

    Pessoa pessoa = Pessoa(nome, peso, altura);

    String imc = pessoa.calcularIMC();

    print("\nDados da pessoa:");
    print("Nome: ${pessoa.nome}");
    print("Peso: ${pessoa.peso} kg");
    print("Altura: ${pessoa.altura} metros");
    print("IMC: $imc");
  } catch (e) {
    print("Ocorreu um erro: $e");
  }
}
