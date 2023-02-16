import 'dart:math';

const mmin = min;
const mmax = max;

abstract class Range<T> {
  T get min;

  T get max;

  T get center;

  bool inside(T value);

  T clamp(T value);
}

class LinearRange implements Range<double> {
  @override
  final double min;
  @override
  final double max;

  @override
  double get center =>
      min.isFinite ?
      max.isFinite ? (max + min) / 2 : min
          : max.isFinite ? max : 0;

  const LinearRange(this.min, this.max) : assert(min <= max);

  const LinearRange.all()
      : min = double.negativeInfinity,
        max = double.infinity;

  @override
  bool inside(double value) => min <= value && value <= max;

  @override
  double clamp(double value) => mmin(mmax(value, min), max);
}

class LogarithmicRange implements Range<double> {
  @override
  final double min;
  @override
  final double max;

  @override
  double get center =>
      (min == 0) ?
      max.isFinite ? exp((log(max) + log(min)) / 2) : min
          : max.isFinite ? min : 1;

  const LogarithmicRange(this.min, this.max)
      : assert(min <= max),
        assert(min >= 0);

  @override
  bool inside(double value) => min <= value && value <= max;

  @override
  double clamp(double value) => mmin(mmax(value, min), max);
}

class AngularRange implements Range<double> {
  @override
  final double min;
  @override
  final double max;

  @override
  double get center =>
      min.isFinite && max.isFinite ?
      (max - (min < max ? min : min - (2 * pi)) / 2) % (2 * pi)
          : 0;

  const AngularRange(min, max)
      : min = min % (2 * pi),
        max = max % (2 * pi);

  const AngularRange.all()
      : min = double.negativeInfinity,
        max = double.infinity;

  @override
  bool inside(double value) {
    final mid = (value - min) % (2 * pi);
    return min.isFinite && max.isFinite
        ? 0 <= mid && mid <= (max - min) % (2*pi)
        : true;
  }

  @override
  double clamp(double value) {
    final minClosest = mmin(
      (min-value).abs(),
      ((min + ((min<value? 1 : -1) * 2*pi) % (2*pi)) - value).abs(),
    );
    final maxClosest = mmin(
      (max-value).abs(),
      ((max + ((max<value? 1 : -1) * 2*pi) % (2*pi)) - value).abs(),
    );
    return minClosest < maxClosest ? min : max;
  }
}
