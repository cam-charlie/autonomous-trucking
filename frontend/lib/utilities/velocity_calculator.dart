class VelocityCalculator {
  final Stopwatch _sw = Stopwatch();
  double _velocity;
  num _prev;
  final num _default;

  VelocityCalculator({required num defaultValue})
      : _default = defaultValue,
        _prev = defaultValue,
        _velocity = 0 {
    _sw.start();
  }

  reset({num? value}) {
    _prev = value ?? _default;
    _sw
      ..reset()
      ..start();
  }

  pushValue(num x) {
    const double oneMillion = 1000000;
    double secondsElapsed = (_sw.elapsedMicroseconds as double) / oneMillion;
    _velocity = (x - _prev) / secondsElapsed;
    _prev = x;
    _sw
      ..reset()
      ..start();
  }

  num get velocity => _velocity;
}