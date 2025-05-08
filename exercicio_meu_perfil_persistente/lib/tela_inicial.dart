// Tela_inicial.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _idadeController = TextEditingController();
  String _corSelecionada = 'Azul';
  Color _corFundo = Colors.white;

  String _nomeSalvo = '';
  String _idadeSalva = '';
  String _corSalva = '';

  final Map<String, Color> coresDisponiveis = {
    'Azul': Colors.blue,
    'Verde': Colors.green,
    'Vermelho': Colors.red,
    'Rosa': Colors.pink,
    'Roxo': Colors.deepPurple
  };

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _salvarDados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('nome', _nomeController.text);
    await prefs.setString('idade', _idadeController.text);
    await prefs.setString('cor', _corSelecionada);

    setState(() {
      _nomeSalvo = _nomeController.text;
      _idadeSalva = _idadeController.text;
      _corSalva = _corSelecionada;
      _corFundo = coresDisponiveis[_corSalva]!;
    });
  }

  Future<void> _carregarDados() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomeSalvo = prefs.getString('nome') ?? '';
      _idadeSalva = prefs.getString('idade') ?? '';
      _corSalva = prefs.getString('cor') ?? 'Azul';
      _corFundo = coresDisponiveis[_corSalva] ?? Colors.white;
      _nomeController.text = _nomeSalvo;
      _idadeController.text = _idadeSalva;
      _corSelecionada = _corSalva;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _corFundo,
      appBar: AppBar(
        title: const Text('Informações Pessoais'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _idadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Idade'),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _corSelecionada,
              onChanged: (String? novaCor) {
                setState(() {
                  _corSelecionada = novaCor!;
                });
              },
              items: coresDisponiveis.keys.map((String cor) {
                return DropdownMenuItem<String>(
                  value: cor,
                  child: Text(cor),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarDados,
              child: const Text('Salvar Dados'),
            ),
            const SizedBox(height: 20),
            Text('Nome salvo: $_nomeSalvo'),
            Text('Idade salva: $_idadeSalva'),
            Text('Cor favorita: $_corSalva'),
          ],
        ),
      ),
    );
  }
}