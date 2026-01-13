import 'package:flutter/material.dart';
import 'package:imc_flutter/models/imc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IMCCalculator(),
    );
  }
}

class IMCCalculator extends StatefulWidget {
  const IMCCalculator({Key? key}) : super(key: key);

  @override
  State<IMCCalculator> createState() => _IMCCalculatorState();
}

class _IMCCalculatorState extends State<IMCCalculator> {
  final List<IMC> imcRecords = [];
  var nomeController = TextEditingController(text: "");
  var pesoController = TextEditingController(text: "");
  var alturaController = TextEditingController(text: "");

  void _imcform() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'Nome'),
                  keyboardType: TextInputType.name,
                  controller: nomeController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Peso (kg)'),
                  keyboardType: TextInputType.number,
                  controller: pesoController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Altura (cm)'),
                  keyboardType: TextInputType.number,
                  controller: alturaController,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    try {
                      IMC dados = IMC(
                        nome: nomeController.text,
                        peso: double.parse(pesoController.text),
                        altura: double.parse(alturaController.text),
                      );
                      dados.calcularIMC();

                      setState(() {
                        imcRecords.add(dados);
                        nomeController.text = "";
                        pesoController.text = "";
                        alturaController.text = "";
                      });
                      Navigator.pop(context);
                    } catch (e) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Erro: $e"),
                        ),
                      );
                    }
                  },
                  child: const Text('Salvar e Calcular'),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de IMC Calculados'),
      ),
      body: ListView.builder(
        itemCount: imcRecords.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                'Nome: ${imcRecords[index].nome}\nPeso: ${imcRecords[index].peso}\nAltura: ${imcRecords[index].altura}\nIMC: ${imcRecords[index].valor?.toStringAsFixed(2)}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _imcform,
        tooltip: 'Calcular IMC',
        child: const Icon(Icons.add),
      ),
    );
  }
}
