import 'package:flutter/material.dart';

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
  int gridSize = 4; // padrão: fácil

  void _selecionarDificuldade(String nivel) {
    setState(() {
      dificuldade = nivel;
      movimentos = 0;

      if (nivel == 'Fácil') {
        gridSize = 4;
      } else if (nivel == 'Médio') {
        gridSize = 5;
      } else if (nivel == 'Difícil') {
        gridSize = 6;
      }
    });
  }

  void _mover(String direcao) {
    setState(() {
      movimentos++;
    });
    print('Movimentou para $direcao');
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
            // Informações do topo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Movimentos: $movimentos",
                    style: const TextStyle(fontSize: 18)),
                Text("Dificuldade: $dificuldade",
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),

            // Botões de dificuldade
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => _selecionarDificuldade('Fácil'),
                    child: const Text("Nível Fácil")),
                ElevatedButton(
                    onPressed: () => _selecionarDificuldade('Médio'),
                    child: const Text("Nível Médio")),
                ElevatedButton(
                    onPressed: () => _selecionarDificuldade('Difícil'),
                    child: const Text("Nível Difícil")),
              ],
            ),
            const SizedBox(height: 30),

            // Grade dinâmica
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
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '', // futuro: números do jogo
                        style: TextStyle(fontSize: 24),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botões de seta
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  iconSize: 40,
                  onPressed: () => _mover('Cima'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      iconSize: 40,
                      onPressed: () => _mover('Esquerda'),
                    ),
                    const SizedBox(width: 40),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      iconSize: 40,
                      onPressed: () => _mover('Direita'),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 40,
                  onPressed: () => _mover('Baixo'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
