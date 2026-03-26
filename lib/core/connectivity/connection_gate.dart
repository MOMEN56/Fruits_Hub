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
    this.hideChildWhenOffline = true,
  });

  final Widget child;
  final bool hasUsableCache;
  final bool requiresInternet;
  final Future<void> Function()? onRetry;
  final String? noNetworkTitle;
  final String? noNetworkMessage;
  final String? noInternetTitle;
  final String? noInternetMessage;
  final bool hideChildWhenOffline;

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
            return _buildOfflineView(
              context,
              title: noNetworkTitle,
              message: noNetworkMessage,
            );
          case ConnectionStatus.connectedNoInternet:
            return _buildOfflineView(
              context,
              title: noInternetTitle,
              message: noInternetMessage,
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

  Widget _buildOfflineView(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    final noConnectionView = NoConnectionView(
      title: title,
      message: message,
      onRetry: widget.onRetry == null
          ? null
          : () {
              _retry();
            },
    );

    if (widget.hideChildWhenOffline) {
      return noConnectionView;
    }

    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: ColoredBox(
            color: Colors.black.withOpacity(0.4),
            child: noConnectionView,
          ),
        ),
      ],
    );
  }
}
