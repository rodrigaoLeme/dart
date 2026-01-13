class IMC {
  double peso;

  IMC(this.peso);

  double calcularIMC(double altura) {
    return peso / (altura * altura);
  }
}
