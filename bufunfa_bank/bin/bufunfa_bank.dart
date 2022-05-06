void main(List<String> arguments) {
  ContaCorrente x =
      ContaCorrente(numeroDaConta: 123, titular: 'José', saldo: 5000);
  ContaPoupanca y =
      ContaPoupanca(numeroDaConta: 456, titular: 'Maria', saldo: 1000);

  print(x.getSaldo());
  x.depositar(valor: 1000);
  print(x.getSaldo());
  x.transferir(contaDestino: y, valorParaTransferir: 1000);
  print(y.getSaldo());
  print(x.getSaldo());
  x.sacarComCPMF(valor: 2000, cobraCPMF: true);
  print(x.getSaldo());
}

class Conta {
  int numeroDaConta;
  String titular;
  double saldo;

  Conta(
      {required this.numeroDaConta,
      required this.titular,
      required this.saldo});

  bool sacar({required double valor}) {
    if (valor < saldo) {
      saldo -= valor;
      return true;
    }
    return false;
  }

  bool depositar({required double valor}) {
    saldo += valor;
    return true;
  }

  bool transferir(
      {required Conta contaDestino, required double valorParaTransferir}) {
    bool retirou = sacar(valor: valorParaTransferir);
    if (retirou) {
      contaDestino.depositar(valor: valorParaTransferir);
      return true;
    }
    return false;
  }

  double getSaldo() {
    return saldo;
  }
}

class ContaPoupanca extends Conta implements Taxas {
  ContaPoupanca(
      {required int numeroDaConta,
      required String titular,
      required double saldo})
      : super(numeroDaConta: numeroDaConta, titular: titular, saldo: saldo);

  @override
  void gerarTaxas() {
    saldo += saldo * 0.006;
  }
}

class ContaCorrente extends Conta implements Taxas {
  ContaCorrente(
      {required int numeroDaConta,
      required String titular,
      required double saldo})
      : super(numeroDaConta: numeroDaConta, titular: titular, saldo: saldo);

  bool sacarComCPMF({required double valor, required bool cobraCPMF}) {
    if (cobraCPMF) {
      return super.sacar(valor: valor + valor * 0.0038);
    }
    return super.sacar(valor: valor);
  }

  @override
  void gerarTaxas() {
    saldo -= 15.90;
  }
}

abstract class Taxas {
  void gerarTaxas();
}
