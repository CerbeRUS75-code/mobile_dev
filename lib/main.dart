import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AudioFormScreen(),
    );
  }
}

class AudioFormScreen extends StatefulWidget {
  const AudioFormScreen({super.key});

  @override
  State<AudioFormScreen> createState() => _AudioFormScreenState();
}

class _AudioFormScreenState extends State<AudioFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mode = TextEditingController();
  final _frequency = TextEditingController();
  final _depth = TextEditingController();
  final _duration = TextEditingController();
  bool _consent = false;

  @override
  void dispose() {
    _mode.dispose();
    _frequency.dispose();
    _depth.dispose();
    _duration.dispose();
    super.dispose();
  }

  String? _positiveInteger(String? value) {
    final number = int.tryParse(value?.trim() ?? '');
    if (number == null || number <= 0) return 'Введите целое число больше нуля';
    return null;
  }

  String? _validateMode(String? value) {
    if (value?.trim() != '1' && value?.trim() != '2') {
      return 'Введите 1 для моно или 2 для стерео';
    }
    return null;
  }

  String? _validateDuration(String? value) {
    final number = double.tryParse((value ?? '').trim().replaceAll(',', '.'));
    if (number == null || !number.isFinite || number <= 0) {
      return 'Введите число больше нуля';
    }
    return null;
  }

  void _calculate() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          channels: int.parse(_mode.text.trim()),
          frequency: int.parse(_frequency.text.trim()),
          depth: int.parse(_depth.text.trim()),
          duration: double.parse(_duration.text.trim().replaceAll(',', '.')),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Миронов Никита Сергеевич')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Объём несжатого звукового файла'),
              TextFormField(
                controller: _mode,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Режим: 1 — моно, 2 — стерео',
                ),
                validator: _validateMode,
              ),
              TextFormField(
                controller: _frequency,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Частота дискретизации, Гц',
                ),
                validator: _positiveInteger,
              ),
              TextFormField(
                controller: _depth,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Глубина кодирования, бит',
                ),
                validator: _positiveInteger,
              ),
              TextFormField(
                controller: _duration,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Длительность, секунды',
                ),
                validator: _validateDuration,
              ),
              FormField<bool>(
                initialValue: false,
                validator: (value) =>
                    value == true ? null : 'Необходимо согласие',
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Согласие на обработку данных'),
                      value: _consent,
                      onChanged: (value) {
                        setState(() => _consent = value ?? false);
                        field.didChange(_consent);
                      },
                    ),
                    if (field.hasError)
                      Text(
                        field.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _calculate,
                child: const Text('Рассчитать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.channels,
    required this.frequency,
    required this.depth,
    required this.duration,
  });

  final int channels;
  final int frequency;
  final int depth;
  final double duration;

  @override
  Widget build(BuildContext context) {
    final bytes = frequency.toDouble() * channels * depth * duration / 8;
    return Scaffold(
      appBar: AppBar(title: const Text('Миронов Никита Сергеевич')),
      body: Center(
        child: Text('Объём файла: ${bytes.toStringAsFixed(2)} байт'),
      ),
    );
  }
}
