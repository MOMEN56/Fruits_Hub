import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub/generated/l10n.dart';

import 'connection_cubit.dart';
import 'connection_status.dart';
import 'no_connection_view.dart';

class ConnectionGate extends StatefulWidget {
  const ConnectionGate({
    super.key,
    required this.child,
    required this.hasUsableCache,
    this.requiresInternet = true,
    this.onRetry,
    this.noNetworkTitle,
    this.noNetworkMessage,
    this.noInternetTitle,
    this.noInternetMessage,
  });

  final Widget child;
  final bool hasUsableCache;
  final bool requiresInternet;
  final Future<void> Function()? onRetry;
  final String? noNetworkTitle;
  final String? noNetworkMessage;
  final String? noInternetTitle;
  final String? noInternetMessage;

  @override
  State<ConnectionGate> createState() => _ConnectionGateState();
}

class _ConnectionGateState extends State<ConnectionGate> {
  bool _isRecovering = false;

  Future<void> _retry() async {
    if (_isRecovering || widget.onRetry == null) {
      return;
    }

    final connectionCubit = context.read<ConnectionCubit>();
    await connectionCubit.refresh();
    if (connectionCubit.state != ConnectionStatus.online) {
      return;
    }

    setState(() {
      _isRecovering = true;
    });

    try {
      await widget.onRetry!();
    } finally {
      if (mounted) {
        setState(() {
          _isRecovering = false;
        });
      }
    }
  }

  bool _wasOffline(ConnectionStatus status) {
    return status == ConnectionStatus.noNetwork ||
        status == ConnectionStatus.connectedNoInternet;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final noNetworkTitle = widget.noNetworkTitle ?? l10n.noNetworkTitle;
    final noNetworkMessage = widget.noNetworkMessage ?? l10n.noNetworkMessage;
    final noInternetTitle = widget.noInternetTitle ?? l10n.noInternetTitle;
    final noInternetMessage =
        widget.noInternetMessage ?? l10n.noInternetMessage;

    if (!widget.requiresInternet || widget.hasUsableCache) {
      return widget.child;
    }

    return BlocConsumer<ConnectionCubit, ConnectionStatus>(
      listenWhen:
          (previous, current) =>
              _wasOffline(previous) && current == ConnectionStatus.online,
      listener: (context, state) {
        _retry();
      },
      builder: (context, status) {
        switch (status) {
          case ConnectionStatus.noNetwork:
            return NoConnectionView(
              title: noNetworkTitle,
              message: noNetworkMessage,
              onRetry:
                  widget.onRetry == null
                      ? null
                      : () {
                        _retry();
                      },
            );
          case ConnectionStatus.connectedNoInternet:
            return NoConnectionView(
              title: noInternetTitle,
              message: noInternetMessage,
              onRetry:
                  widget.onRetry == null
                      ? null
                      : () {
                        _retry();
                      },
            );
          case ConnectionStatus.checking:
            return const Center(child: CircularProgressIndicator());
          case ConnectionStatus.online:
            if (_isRecovering) {
              return const Center(child: CircularProgressIndicator());
            }
            return widget.child;
        }
      },
    );
  }
}
