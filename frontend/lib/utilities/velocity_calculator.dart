class VelocityCalculator<T extends num> {
  final Stopwatch _sw = Stopwatch();
  double _velocity = 0;
  T? _prev;

  VelocityCalculator() {
    _sw.start();
  }

  reset({T? value}) {
    _prev = value;
    _sw
      ..reset()
      ..start();
  }

  pushValue(T x) {
    const double oneMillion = 1000000;
    double secondsElapsed = (_sw.elapsedMicroseconds as double) / oneMillion;
    if (secondsElapsed == 0 || _prev == null) {
      _velocity = 0;
    } else {
      _velocity = (x - _prev!) / secondsElapsed;
    }
    _prev = x;
    _sw
      ..reset()
      ..start();
  }

  double get velocity => _velocity;
}