import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'history_cubit.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('История расчётов')),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HistoryError) {
            return const Center(child: Text('Не удалось загрузить историю'));
          }
          final records = (state as HistoryLoaded).records;
          if (records.isEmpty) {
            return const Center(child: Text('Сохранённых расчётов пока нет'));
          }
          return ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final mode = record['channels'] == 1 ? 'моно' : 'стерео';
              final bytes = (record['bytes'] as num).toDouble();
              final date = DateTime.parse(record['created_at'] as String);
              final formattedDate =
                  '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Объём файла: ${bytes.toStringAsFixed(2)} байт'),
                      Text(formattedDate),
                      Text('Режим: $mode'),
                      Text('Частота: ${record['frequency']} Гц'),
                      Text('Глубина: ${record['depth']} бит'),
                      Text('Длительность: ${record['duration']} с'),
                      Text(
                        'Согласие: ${record['consent'] == 1 ? 'да' : 'нет'}',
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
