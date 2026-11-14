import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/audio_cubit.dart';
import 'cubit/audio_state.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => AudioCubit(),
        child: const AudioScreen(),
      ),
    );
  }
}

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
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
    if (!_formKey.currentState!.validate()) {
      context.read<AudioCubit>().edit();
      return;
    }
    FocusScope.of(context).unfocus();
    context.read<AudioCubit>().calculate(
      channels: int.parse(_mode.text.trim()),
      frequency: int.parse(_frequency.text.trim()),
      depth: int.parse(_depth.text.trim()),
      duration: double.parse(_duration.text.trim().replaceAll(',', '.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Миронов Никита Сергеевич')),
          body: _buildForm(state),
        );
      },
    );
  }

  Widget _buildForm(AudioState state) {
    return SingleChildScrollView(
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
              initialValue: _consent,
              validator: (value) =>
                  value == true ? null : 'Необходимо согласие',
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Согласие на обработку данных'),
                    value: field.value,
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
            if (state is AudioResult) ...[
              const SizedBox(height: 16),
              Text('Объём файла: ${state.bytes.toStringAsFixed(2)} байт'),
            ],
          ],
        ),
      ),
    );
  }
}
