import 'package:test/test.dart';
import 'package:imc/models/pessoa.dart'; // Importe o arquivo da classe Pessoa

void main() {
  test("Calcula IMC corretamente", () {
    Pessoa pessoa = Pessoa("João", 70, 1.75);
    expect(pessoa.calcularIMC(), equals('22.86'));
  });

  test("Trata exceção para valores inválidos", () {
    Pessoa pessoa = Pessoa("Maria", 0, 1.65);
    expect(() => pessoa.calcularIMC(), throwsException);
  });
}
