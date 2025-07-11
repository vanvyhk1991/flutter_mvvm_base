import 'dart:async';

class InMemoryCache {
  static String? _token;
  static final _controller = StreamController<void>.broadcast();

  static String? get token => _token;

  static set token(String? value) {
    _token = value;
    _controller.add(null); // Trigger refresh
  }

  static Stream<void> get authStream => _controller.stream;
}