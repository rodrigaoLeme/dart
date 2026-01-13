import 'package:flutter/material.dart';
import 'package:imc_flutter/models/imc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  //Hive.init(appDocumentDir.path);
  //await Hive.openBox('imcBox');
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
    alturaController.text = prefs.getDouble('altura').toString();
    setState(() {});
  }

  _salvarInformacoes() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    await prefs.setString('nome', nomeController.text);
    await prefs.setDouble('altura', double.parse(alturaController.text));
    carregarDados();
  }

  _calcularIMC(double altura) {
    double peso = double.parse(pesoController.text);
    IMC imc = IMC(peso);
    double resultado = imc.calcularIMC(altura);
    var box = Hive.box('imcBox');
    box.add(resultado);
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
                onPressed: _salvarInformacoes(),
                // onPressed: () {
                //   try {
                //     IMC dados = IMC(
                //       nome: nomeController.text,
                //       peso: double.parse(pesoController.text),
                //       altura: double.parse(alturaController.text),
                //     );
                //     dados.calcularIMC();

                //     setState(() {
                //       imcRecords.add(dados);
                //       nomeController.text = "";
                //       pesoController.text = "";
                //       alturaController.text = "";
                //     });
                //     Navigator.pop(context);
                //   } catch (e) {
                //     Navigator.pop(context);
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(
                //         content: Text("Erro: $e"),
                //       ),
                //     );
                //   }
                // },
                child: const Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  /*
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
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de IMC Calculados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Open shopping cart',
            onPressed: _userScreen,
          ),
        ],
      ),
      body: Container(),
      /*
      body: ListView.builder(
        itemCount: imcRecords.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                'Nome: ${imcRecords[index].nome}\nPeso: ${imcRecords[index].peso}\nAltura: ${imcRecords[index].altura}\nIMC: ${imcRecords[index].valor?.toStringAsFixed(2)}'),
          );
        },
      ),
      */
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _imcform,
      //   tooltip: 'Calcular IMC',
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
