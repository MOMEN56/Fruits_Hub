import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'connection_service.dart';
import 'connection_status.dart';

class ConnectionCubit extends Cubit<ConnectionStatus> {
  ConnectionCubit(this._connectionService) : super(ConnectionStatus.checking);

  final ConnectionService _connectionService;
  StreamSubscription<ConnectionStatus>? _subscription;

  Future<void> start() async {
    if (_subscription != null) {
      return;
    }

    _subscription = _connectionService.stream.listen(emit);
    await _connectionService.startMonitoring();
    if (state != _connectionService.currentStatus) {
      emit(_connectionService.currentStatus);
    }
  }

  Future<void> refresh() {
    return _connectionService.refreshStatus();
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    await _connectionService.dispose();
    return super.close();
  }
}
