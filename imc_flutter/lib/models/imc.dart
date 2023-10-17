class IMC {
  String nome;
  double peso;
  double altura;
  double? valor;

  IMC({required this.nome, required this.peso, required this.altura});

  calcularIMC() {
    if (altura <= 0 || peso <= 0) {
      throw Exception("Altura e peso devem ser valores positivos.");
    }
    valor = ((altura * altura) / peso);
  }
}
