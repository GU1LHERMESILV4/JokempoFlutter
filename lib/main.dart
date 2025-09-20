// main.dart
// Jogo completo de Jokempo (Pedra, Papel, Tesoura) com detecção de chacoalhar
// Dependências: sensors_plus (para detectar acelerômetro)

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const JokempoApp());
}

enum Move { rock, paper, scissors }

extension MoveExt on Move {
  String get label {
    switch (this) {
      case Move.rock:
        return 'Pedra';
      case Move.paper:
        return 'Papel';
      case Move.scissors:
        return 'Tesoura';
    }
  }

  String get emoji {
    switch (this) {
      case Move.rock:
        return '🪨';
      case Move.paper:
        return '📄';
      case Move.scissors:
        return '✂️';
    }
  }
}

class JokempoApp extends StatelessWidget {
  const JokempoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Jokempo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Move? _playerMove;
  Move? _cpuMove;
  String _result = '';
  int _playerScore = 0;
  int _cpuScore = 0;

  // Shake detection
  StreamSubscription<AccelerometerEvent>? _accSub;
  final _rand = Random();
  DateTime _lastShake = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();
    _startListeningShake();
  }

  @override
  void dispose() {
    _accSub?.cancel();
    super.dispose();
  }

  void _startListeningShake() {
    // Simple shake detection: calcula magnitude do vetor acelerômetro
    const double shakeThreshold = 18.0; // ajuste conforme necessário
    const int shakeCooldownMs = 800;

    _accSub = accelerometerEvents.listen((AccelerometerEvent event) {
      final double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      if (magnitude > shakeThreshold) {
        final now = DateTime.now();
        if (now.difference(_lastShake).inMilliseconds > shakeCooldownMs) {
          _lastShake = now;
          _onShaken();
        }
      }
    });
  }

  void _onShaken() {
    // Ao chacoalhar, muda a opção do jogador aleatoriamente (com feedback)
    final newMove = Move.values[_rand.nextInt(Move.values.length)];
    setState(() {
      _playerMove = newMove;
    });
    HapticFeedback.mediumImpact();
    // Opcional: tocar som se desejar (não incluído)
  }

  void _play(Move playerSelection) {
    final cpuSelection = Move.values[_rand.nextInt(Move.values.length)];
    final result = _decideResult(playerSelection, cpuSelection);

    setState(() {
      _playerMove = playerSelection;
      _cpuMove = cpuSelection;
      _result = result;
      if (result == 'Você venceu') _playerScore++;
      if (result == 'Você perdeu') _cpuScore++;
    });
  }

  String _decideResult(Move player, Move cpu) {
    if (player == cpu) return 'Empate';
    if ((player == Move.rock && cpu == Move.scissors) ||
        (player == Move.paper && cpu == Move.rock) ||
        (player == Move.scissors && cpu == Move.paper)) {
      return 'Você venceu';
    }
    return 'Você perdeu';
  }

  void _reset() {
    setState(() {
      _playerMove = null;
      _cpuMove = null;
      _result = '';
      _playerScore = 0;
      _cpuScore = 0;
    });
  }

  Widget _buildMoveButton(Move move) {
    return ElevatedButton(
      onPressed: () => _play(move),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(move.emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 6),
          Text(move.label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jokempo'),
        actions: [
          IconButton(
            tooltip: 'Resetar placar',
            onPressed: _reset,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Você', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(_playerMove?.emoji ?? '—', style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 6),
                        Text(_playerMove?.label ?? ''),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Placar', style: Theme.of(context).textTheme.titleSmall),
                        const SizedBox(height: 6),
                        Text('$_playerScore : $_cpuScore', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('CPU', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(_cpuMove?.emoji ?? '—', style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 6),
                        Text(_cpuMove?.label ?? ''),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_result, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const Text('Escolha sua jogada ou chacoalhe o celular', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMoveButton(Move.rock),
                        _buildMoveButton(Move.paper),
                        _buildMoveButton(Move.scissors),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton.icon(
                onPressed: () {
                  // Mostrar ajuda rápida sobre chacoalhar
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Como usar'),
                      content: const Text('Chacoalhe o dispositivo para trocar sua jogada aleatoriamente. Ajuste a sensibilidade no código se necessário.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: const Text('Ajuda'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
