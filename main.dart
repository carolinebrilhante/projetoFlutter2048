import 'dart:math';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo 2048',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Jogo 2048'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int movimentos = 0;
  String dificuldade = 'Nenhuma';
  int gridSize = 4;
  int objetivo = 1024;
  late List<List<int>> board;
  String mensagemFinal = '';

  @override
  void initState() {
    super.initState();
    _inicializarTabuleiro();
  }

  void _inicializarTabuleiro() {
    board = List.generate(gridSize, (_) => List.filled(gridSize, 0));
    mensagemFinal = '';
    _adicionarNovaPeca();
  }

  void _adicionarNovaPeca() {
    final vazio = <List<int>>[];
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (board[i][j] == 0) {
          vazio.add([i, j]);
        }
      }
    }
    if (vazio.isNotEmpty) {
      final pos = vazio[Random().nextInt(vazio.length)];
      board[pos[0]][pos[1]] = 1;
    }
  }

  void _selecionarDificuldade(String nivel) {
    setState(() {
      dificuldade = nivel;
      movimentos = 0;
      mensagemFinal = '';

      if (nivel == 'Fácil') {
        gridSize = 4;
        objetivo = 1024;
      } else if (nivel == 'Médio') {
        gridSize = 5;
        objetivo = 2048;
      } else if (nivel == 'Difícil') {
        gridSize = 6;
        objetivo = 4096;
      }

      _inicializarTabuleiro();
    });
  }

  void _mover(String direcao) {
    if (mensagemFinal.isNotEmpty) return;

    bool mudou = false;

    setState(() {
      switch (direcao) {
        case 'Esquerda':
          mudou = _moverEsquerda();
          break;
        case 'Direita':
          mudou = _moverDireita();
          break;
        case 'Cima':
          mudou = _moverCima();
          break;
        case 'Baixo':
          mudou = _moverBaixo();
          break;
      }

      if (mudou) {
        movimentos++;
        _adicionarNovaPeca();
        _verificarFimDeJogo();
      }
    });
  }

  void _verificarFimDeJogo() {
    for (var linha in board) {
      if (linha.contains(objetivo)) {
        mensagemFinal = 'VOCÊ GANHOU';
        return;
      }
    }

    for (var linha in board) {
      if (linha.contains(0)) return;
    }

    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize - 1; j++) {
        if (board[i][j] == board[i][j + 1] || board[j][i] == board[j + 1][i]) {
          return;
        }
      }
    }

    mensagemFinal = 'VOCÊ PERDEU';
  }

  bool _moverEsquerda() {
    bool mudou = false;

    for (int i = 0; i < gridSize; i++) {
      List<int> novaLinha = board[i].where((v) => v != 0).toList();
      for (int j = 0; j < novaLinha.length - 1; j++) {
        if (novaLinha[j] == novaLinha[j + 1]) {
          novaLinha[j] *= 2;
          novaLinha[j + 1] = 0;
          mudou = true;
        }
      }
      novaLinha = novaLinha.where((v) => v != 0).toList();
      while (novaLinha.length < gridSize) {
        novaLinha.add(0);
      }

      if (!mudou && !ListEquality().equals(board[i], novaLinha)) {
        mudou = true;
      }

      board[i] = novaLinha;
    }

    return mudou;
  }

  bool _moverDireita() {
    _espelharHorizontal();
    bool mudou = _moverEsquerda();
    _espelharHorizontal();
    return mudou;
  }

  bool _moverCima() {
    _transpor();
    bool mudou = _moverEsquerda();
    _transpor();
    return mudou;
  }

  bool _moverBaixo() {
    _transpor();
    bool mudou = _moverDireita();
    _transpor();
    return mudou;
  }

  void _espelharHorizontal() {
    for (int i = 0; i < gridSize; i++) {
      board[i] = board[i].reversed.toList();
    }
  }

  void _transpor() {
    List<List<int>> nova = List.generate(gridSize, (_) => List.filled(gridSize, 0));
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        nova[i][j] = board[j][i];
      }
    }
    board = nova;
  }

  @override
  Widget build(BuildContext context) {
    int totalCells = gridSize * gridSize;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Movimentos: $movimentos", style: const TextStyle(fontSize: 18)),
                Text("Dificuldade: $dificuldade", style: const TextStyle(fontSize: 18)),
              ],
            ),
            if (mensagemFinal.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  mensagemFinal,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () => _selecionarDificuldade('Fácil'), child: const Text("Nível Fácil")),
                ElevatedButton(onPressed: () => _selecionarDificuldade('Médio'), child: const Text("Nível Médio")),
                ElevatedButton(onPressed: () => _selecionarDificuldade('Difícil'), child: const Text("Nível Difícil")),
              ],
            ),
            const SizedBox(height: 30),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1,
                child: GridView.builder(
                  itemCount: totalCells,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    int row = index ~/ gridSize;
                    int col = index % gridSize;
                    int value = board[row][col];
                    return Container(
                      decoration: BoxDecoration(
                        color: value == 0
                            ? Colors.grey[300]
                            : Colors.orange[100 * (value.toRadixString(2).length % 9)],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        value == 0 ? '' : '$value',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                IconButton(icon: const Icon(Icons.arrow_upward), iconSize: 40, onPressed: () => _mover('Cima')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back), iconSize: 40, onPressed: () => _mover('Esquerda')),
                    const SizedBox(width: 40),
                    IconButton(icon: const Icon(Icons.arrow_forward), iconSize: 40, onPressed: () => _mover('Direita')),
                  ],
                ),
                IconButton(icon: const Icon(Icons.arrow_downward), iconSize: 40, onPressed: () => _mover('Baixo')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
