import 'dart:io';

void main() {
  final scanner = stdin;

  final entrada = scanner.readLineSync()!;
  final partes = entrada.split(',');

  // TODO: Solicitar ao usuário que forneça os valores necessários para criar uma Transacao.
  Transacao trans =
      Transacao(partes[0], partes[1], partes[2], double.parse(partes[3]));
  trans.imprimir();
}

class Transacao {
  final String data;
  final String hora;
  final String descricao;
  final double valor;

  Transacao(this.data, this.hora, this.descricao, this.valor);

  void imprimir() {
    print(descricao);
    print(data);
    print(hora);
    print(valor.toStringAsFixed(2));
  }
}


// import 'dart:io';

// void main() {
//   final scanner = Scanner();
//   final dataInicial = scanner.nextLine();
//   final dataFinal = scanner.nextLine();

//   final sistemaAcionistas = SistemaAcionistas();
//   final analises =
//       sistemaAcionistas.obterAnalisesDesempenho(dataInicial, dataFinal);

//   for (final analise in analises) {
//     print(analise);
//   }
// }

// class Scanner {
//   final _input = stdin;

//   String nextLine() {
//     return _input.readLineSync()!;
//   }
// }

// class SistemaAcionistas {
//   List<String> obterAnalisesDesempenho(
//       String dataInicialStr, String dataFinalStr) {
//     final dataInicial = _parseDate(dataInicialStr);
//     final dataFinal = _parseDate(dataFinalStr);

//     final analises = <Analise>[
//       Analise(_parseDate('01/01/2023'), 'Analise de Desempenho Financeiro'),
//       Analise(_parseDate('15/02/2023'), 'Analise de Riscos e Exposicoes'),
//       Analise(_parseDate('31/03/2023'), 'Analises Corporativas'),
//       Analise(
//           _parseDate('01/04/2023'), 'Analise de Politicas e Regulamentacoes'),
//       Analise(_parseDate('15/05/2023'), 'Analise de Ativos'),
//       Analise(_parseDate('30/06/2023'), 'Analise de Inovacao e Tecnologia'),
//     ];

//     //TODO: Implemente o filtro das análises dentro do período especificado. Dica: Crie uma lista para armazenar as análises filtradas e use um loop for para filtrar as análises.
//     List<String> analisesFiltradas = [];

//     // TODO: Retorne a lista de análises filtradas.
//     for (final analise in analises) {
//       if (analise.data.isAfter(dataInicial) &&
//               analise.data.isBefore(dataFinal) ||
//           analise.data.isAtSameMomentAs(dataInicial) ||
//           analise.data.isAtSameMomentAs(dataFinal)) {
//         //if (analise.descricao == 'Analise de Desempenho Financeiro') {
//         analisesFiltradas.add(analise.descricao);
//         //}
//       }
//     }

//     return analisesFiltradas;
//   }

//   DateTime _parseDate(String dateStr) {
//     final parts = dateStr.split('/');
//     final day = int.parse(parts[0]);
//     final month = int.parse(parts[1]);
//     final year = int.parse(parts[2]);
//     return DateTime(year, month, day);
//   }
// }

// class Analise {
//   final DateTime data;
//   final String descricao;

//   Analise(this.data, this.descricao);
// }


// import 'dart:io';

// abstract class Cofre {
//   final String tipo;
//   final String metodoAbertura;

//   Cofre(this.tipo, this.metodoAbertura);

//   void imprimirInformacoes() {
//     print('Tipo: $tipo');
//     print('Metodo de abertura: $metodoAbertura');
//   }
// }

// class CofreDigital extends Cofre {
//   final int senha;

//   CofreDigital(this.senha) : super('Cofre Digital', 'Senha');

//   bool validarSenha(int confirmacaoSenha) {
//     return confirmacaoSenha == senha;
//   }
// }

// class CofreFisico extends Cofre {
//   CofreFisico() : super('Cofre Fisico', 'Chave');

//   @override
//   void imprimirInformacoes() {
//     print('Tipo: $tipo');
//     print('Metodo de abertura: $metodoAbertura');
//   }
// }

// void main() {
//   final tipoCofre = stdin.readLineSync();

//   if (tipoCofre?.toLowerCase() == 'digital') {
//     final senha = int.tryParse(stdin.readLineSync() ?? '');
//     final confirmacaoSenha = int.tryParse(stdin.readLineSync() ?? '');

//     if (senha != null && confirmacaoSenha != null) {
//       final cofre = CofreDigital(senha);
//       cofre.imprimirInformacoes();
//       (cofre.validarSenha(confirmacaoSenha))
//           ? print("Cofre aberto!")
//           : print("Senha incorreta!");
//     }
//   } else {
//     final cofre = CofreFisico();
//     cofre.imprimirInformacoes();
//   }
// }



// import 'dart:io';

// class Bancaria {
//   int numeroConta;
//   String nomeTitular;
//   double saldo;

//   Bancaria(this.numeroConta, this.nomeTitular, this.saldo);

//   void exibirInformacoes() {
//     print(nomeTitular);
//     print(numeroConta);
//     print("Saldo: R\$ ${saldo.toStringAsFixed(1)}");
//   }
// }

// class ContaPoupanca extends Bancaria {
//   double taxaJuros;

//   ContaPoupanca(
//       int numeroConta, String nomeTitular, double saldo, this.taxaJuros)
//       : super(numeroConta, nomeTitular, saldo);

//   @override
//   void exibirInformacoes() {
//     super.exibirInformacoes();
//     print("Taxa de juros: ${taxaJuros.toStringAsFixed(1)}%");
//   }
// }

// void main() {
//   String? nomeTitular = stdin.readLineSync();
//   int? numeroConta = int.tryParse(stdin.readLineSync() ?? "");
//   double? saldo = double.tryParse(stdin.readLineSync() ?? "");
//   double? taxaJuros = double.tryParse(stdin.readLineSync() ?? "");

//   if (nomeTitular == null ||
//       numeroConta == null ||
//       saldo == null ||
//       taxaJuros == null) {
//     print("Entrada inválida.");
//     return;
//   }

//   var contaPoupanca = ContaPoupanca(numeroConta, nomeTitular, saldo, taxaJuros);

//   print("Conta Poupanca:");
//   contaPoupanca.exibirInformacoes();
// }



// import 'dart:io';
// import 'dart:math';

// import 'package:imc/models/pessoa.dart';

// class Bancaria {
//   int numeroConta;
//   String nomeTitular;
//   double saldo;

//   Bancaria(this.numeroConta, this.nomeTitular, this.saldo);

//   int getNumeroConta() {
//     return numeroConta;
//   }

//   String getNomeTitular() {
//     return nomeTitular;
//   }

//   double getSaldo() {
//     return saldo;
//   }
// }

// void main(List<String> arguments) {
//   int numeroConta = int.parse(stdin.readLineSync()!);
//   String nomeTitular = stdin.readLineSync()!;
//   double saldo = double.parse(stdin.readLineSync()!);

//   //TODO: Criar uma instância de "ContaBancaria" com os valores de Entrada.
//   Bancaria conta = Bancaria(numeroConta, nomeTitular, saldo);

//   print("Informacoes:");
//   print("Conta: ${conta.getNumeroConta()}");
//   print("Titular: ${conta.getNomeTitular()}");
//   print("Saldo: R\$ ${conta.getSaldo()}");
  //TODO: Imprimir as informações da conta usando o objeto criado no TODO acima.
  // try {
  //   stdout.write("Informe o nome da pessoa: ");
  //   String nome = stdin.readLineSync() ?? "";

  //   stdout.write("Informe o peso da pessoa (em kg): ");
  //   double peso = double.parse(stdin.readLineSync() ?? "0");

  //   stdout.write("Informe a altura da pessoa (em metros): ");
  //   double altura = double.parse(stdin.readLineSync() ?? "0");

  //   Pessoa pessoa = Pessoa(nome, peso, altura);

  //   String imc = pessoa.calcularIMC();

  //   print("\nDados da pessoa:");
  //   print("Nome: ${pessoa.nome}");
  //   print("Peso: ${pessoa.peso} kg");
  //   print("Altura: ${pessoa.altura} metros");
  //   print("IMC: $imc");
  // } catch (e) {
  //   print("Ocorreu um erro: $e");
  // }

  // var valorInicial = double.parse(stdin.readLineSync()!);
  // var taxaJuros = double.parse(stdin.readLineSync()!);
  // var periodo = int.parse(stdin.readLineSync()!);

  // var valorFinal = valorInicial;

  // //TODO: Iterar, baseado no período em anos, para calculo do valorFinal com os juros.
  // valorInicial = valorInicial * (pow((1 + taxaJuros), periodo));
  // //valorFinal = m.toStringAsFixed(2) as double;

  //print("Valor final do investimento: R\$ ${valorInicial.toStringAsFixed(2)}");
//}
