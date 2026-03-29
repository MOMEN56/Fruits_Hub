import 'dart:async';
import 'dart:io';

bool isLikelyNetworkError(Object error) {
  if (error is SocketException || error is TimeoutException) {
    return true;
  }

  final message = error.toString().toLowerCase();
  const networkMarkers = <String>[
    'failed host lookup',
    'lookup: host',
    'network is unreachable',
    'no route to host',
    'temporary failure in name resolution',
    'connection refused',
    'connection reset',
    'connection closed',
    'software caused connection abort',
    'xmlhttprequest error',
    'timed out',
    'errno = 7',
  ];

  if (message.contains('socketexception') ||
      message.contains('timeoutexception')) {
    return true;
  }

  return networkMarkers.any(message.contains);
}
