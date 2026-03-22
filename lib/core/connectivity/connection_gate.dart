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
<<<<<<< HEAD
    this.noNetworkTitle,
    this.noNetworkMessage,
    this.noInternetTitle,
    this.noInternetMessage,
=======
    this.noNetworkTitle =
        '\u0644\u0627 \u064A\u0648\u062C\u062F \u0627\u062A\u0635\u0627\u0644 \u0628\u0627\u0644\u0634\u0628\u0643\u0629',
    this.noNetworkMessage =
        '\u064A\u0628\u062F\u0648 \u0623\u0646\u0643 \u063A\u064A\u0631 \u0645\u062A\u0635\u0644 \u0628\u0623\u064A \u0634\u0628\u0643\u0629 \u062D\u0627\u0644\u064A\u064B\u0627. \u062A\u062D\u0642\u0642 \u0645\u0646 \u0627\u0644\u0648\u0627\u064A \u0641\u0627\u064A \u0623\u0648 \u0628\u064A\u0627\u0646\u0627\u062A \u0627\u0644\u0647\u0627\u062A\u0641.',
    this.noInternetTitle =
        '\u0644\u0627 \u064A\u0648\u062C\u062F \u0627\u062A\u0635\u0627\u0644 \u0628\u0627\u0644\u0625\u0646\u062A\u0631\u0646\u062A',
    this.noInternetMessage =
        '\u0623\u0646\u062A \u0645\u062A\u0635\u0644 \u0628\u0627\u0644\u0634\u0628\u0643\u0629\u060C \u0644\u0643\u0646 \u0644\u0627 \u064A\u0648\u062C\u062F \u0627\u062A\u0635\u0627\u0644 \u0641\u0639\u0644\u064A \u0628\u0627\u0644\u0625\u0646\u062A\u0631\u0646\u062A \u0641\u064A \u0627\u0644\u0648\u0642\u062A \u0627\u0644\u062D\u0627\u0644\u064A.',
>>>>>>> 8209224a4c008167926f14f1325865e44032663a
  });

  final Widget child;
  final bool hasUsableCache;
  final bool requiresInternet;
  final Future<void> Function()? onRetry;
<<<<<<< HEAD
  final String? noNetworkTitle;
  final String? noNetworkMessage;
  final String? noInternetTitle;
  final String? noInternetMessage;
=======
  final String noNetworkTitle;
  final String noNetworkMessage;
  final String noInternetTitle;
  final String noInternetMessage;
>>>>>>> 8209224a4c008167926f14f1325865e44032663a

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
<<<<<<< HEAD
    final l10n = S.of(context);
    final noNetworkTitle = widget.noNetworkTitle ?? l10n.noNetworkTitle;
    final noNetworkMessage = widget.noNetworkMessage ?? l10n.noNetworkMessage;
    final noInternetTitle = widget.noInternetTitle ?? l10n.noInternetTitle;
    final noInternetMessage =
        widget.noInternetMessage ?? l10n.noInternetMessage;

=======
>>>>>>> 8209224a4c008167926f14f1325865e44032663a
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
<<<<<<< HEAD
              title: noNetworkTitle,
              message: noNetworkMessage,
=======
              title: widget.noNetworkTitle,
              message: widget.noNetworkMessage,
>>>>>>> 8209224a4c008167926f14f1325865e44032663a
              onRetry:
                  widget.onRetry == null
                      ? null
                      : () {
                        _retry();
                      },
            );
          case ConnectionStatus.connectedNoInternet:
            return NoConnectionView(
<<<<<<< HEAD
              title: noInternetTitle,
              message: noInternetMessage,
=======
              title: widget.noInternetTitle,
              message: widget.noInternetMessage,
>>>>>>> 8209224a4c008167926f14f1325865e44032663a
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
