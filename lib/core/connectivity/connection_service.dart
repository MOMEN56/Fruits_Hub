import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'connection_status.dart';

class ConnectionService {
  ConnectionService({
    Connectivity? connectivity,
    Uri? probeUri,
    Duration? probeTimeout,
    Duration? probeInterval,
  }) : _connectivity = connectivity ?? Connectivity(),
       _probeUri =
           probeUri ?? Uri.parse('https://clients3.google.com/generate_204'),
       _probeTimeout = probeTimeout ?? const Duration(seconds: 3),
       _probeInterval = probeInterval ?? const Duration(seconds: 6);

  final Connectivity _connectivity;
  final Uri _probeUri;
  final Duration _probeTimeout;
  final Duration _probeInterval;
  final StreamController<ConnectionStatus> _controller =
      StreamController<ConnectionStatus>.broadcast();

  StreamSubscription<dynamic>? _connectivitySubscription;
  Timer? _probeTimer;
  ConnectionStatus _currentStatus = ConnectionStatus.checking;
  bool _isDisposed = false;
  bool _isProbeRunning = false;

  Stream<ConnectionStatus> get stream => _controller.stream;
  ConnectionStatus get currentStatus => _currentStatus;

  Future<void> startMonitoring() async {
    if (_isDisposed || _connectivitySubscription != null) {
      return;
    }

    final initialResult = await _connectivity.checkConnectivity();
    await _handleConnectivityChange(initialResult, forceEmit: true);

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      unawaited(_handleConnectivityChange(result));
    });
  }

  Future<void> refreshStatus() async {
    if (_isDisposed) {
      return;
    }

    final result = await _connectivity.checkConnectivity();
    await _handleConnectivityChange(result, forceEmit: true);
  }

  Future<void> _handleConnectivityChange(
    dynamic result, {
    bool forceEmit = false,
  }) async {
    if (_isDisposed) {
      return;
    }

    final hasNetworkTransport = _hasNetworkTransport(result);
    if (!hasNetworkTransport) {
      _stopProbeTimer();
      _emit(ConnectionStatus.noNetwork, forceEmit: forceEmit);
      return;
    }

    await _probeInternet(forceEmit: forceEmit);
    _startProbeTimer();
  }

  bool _hasNetworkTransport(dynamic result) {
    if (result is ConnectivityResult) {
      return result != ConnectivityResult.none;
    }

    if (result is List<ConnectivityResult>) {
      return result.any((item) => item != ConnectivityResult.none);
    }

    return false;
  }

  void _startProbeTimer() {
    if (_probeTimer?.isActive ?? false) {
      return;
    }

    _probeTimer = Timer.periodic(_probeInterval, (_) {
      unawaited(_probeInternet());
    });
  }

  void _stopProbeTimer() {
    _probeTimer?.cancel();
    _probeTimer = null;
  }

  Future<void> _probeInternet({bool forceEmit = false}) async {
    if (_isDisposed || _isProbeRunning) {
      return;
    }

    _isProbeRunning = true;
    try {
      final isInternetAvailable = await _hasInternetAccess();
      _emit(
        isInternetAvailable
            ? ConnectionStatus.online
            : ConnectionStatus.connectedNoInternet,
        forceEmit: forceEmit,
      );
    } finally {
      _isProbeRunning = false;
    }
  }

  Future<bool> _hasInternetAccess() async {
    final client = HttpClient()..connectionTimeout = _probeTimeout;

    try {
      final request = await client.getUrl(_probeUri).timeout(_probeTimeout);
      request.followRedirects = false;
      final response = await request.close().timeout(_probeTimeout);
      await response.drain<void>();
      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (_) {
      return false;
    } finally {
      client.close(force: true);
    }
  }

  void _emit(ConnectionStatus nextStatus, {bool forceEmit = false}) {
    if (_isDisposed) {
      return;
    }

    if (!forceEmit && nextStatus == _currentStatus) {
      return;
    }

    _currentStatus = nextStatus;
    _controller.add(nextStatus);
  }

  Future<void> dispose() async {
    _isDisposed = true;
    _stopProbeTimer();
    await _connectivitySubscription?.cancel();
    await _controller.close();
  }
}
