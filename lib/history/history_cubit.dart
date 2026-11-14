import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/calculation_storage.dart';

sealed class HistoryState {
  const HistoryState();
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  const HistoryLoaded(this.records);
  final List<Map<String, Object?>> records;
}

class HistoryError extends HistoryState {
  const HistoryError();
}

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit(this.storage) : super(const HistoryLoading());
  final CalculationStorage storage;

  Future<void> load() async {
    emit(const HistoryLoading());
    try {
      final records = await storage.loadHistory();
      if (!isClosed) emit(HistoryLoaded(records));
    } catch (_) {
      if (!isClosed) emit(const HistoryError());
    }
  }
}
