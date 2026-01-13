class Pessoa {
  String nome;
  double peso;
  double altura;

  Pessoa(this.nome, this.peso, this.altura);

  String calcularIMC() {
    if (altura <= 0 || peso <= 0) {
      throw Exception("Altura e peso devem ser valores positivos.");
    }
    return (peso / (altura * altura)).toStringAsFixed(2);
  }
}
