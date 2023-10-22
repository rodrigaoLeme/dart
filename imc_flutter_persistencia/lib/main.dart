import 'package:flutter/material.dart';
import 'package:imc_flutter/models/imc.dart';
import 'package:imc_flutter/models/pessoa.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var nomeController = TextEditingController(text: "");
  var pesoController = TextEditingController(text: "");
  var alturaController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  carregarDados() async {
    final SharedPreferences prefs = await _prefs;
    nomeController.text = prefs.getString('nome') ?? "";
    alturaController.text = (prefs.getDouble('altura') != null)
        ? prefs.getDouble('altura').toString()
        : '0';
    setState(() {});
  }

  Future<void> _salvarInformacoes() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('nome', nomeController.text);
    await prefs.setDouble('altura', double.parse(alturaController.text));
    Navigator.pop(context);
    carregarDados();
  }

  void _userScreen() {
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
                decoration: const InputDecoration(labelText: 'Altura (cm)'),
                keyboardType: TextInputType.number,
                controller: alturaController,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarInformacoes,
                child: const Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de IMC Calculados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: _userScreen,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: imcRecords.length,
        itemBuilder: (context, index) {
          return Container();
          // return ListTile(
          //   title: Text(
          //       'Nome: ${imcRecords[index].nome}\nPeso: ${imcRecords[index].peso}\nAltura: ${imcRecords[index].altura}\nIMC: ${imcRecords[index].valor?.toStringAsFixed(2)}'),
          // );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Calcular IMC',
        child: const Icon(Icons.add),
      ),
    );
  }
}
