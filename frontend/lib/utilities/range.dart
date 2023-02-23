import 'dart:math';
import 'dart:ui';

const mmin = min;
const mmax = max;

/*
TODO:
  - [] make this whole file nicer. better constructors, less useless stuff
  - [] make a rect one?

 */

abstract class Range<T> {
  T get min;

  T get max;

  bool contains(T value);

  T clamp(T value);

  T distance(T value);
}

class LinearRange implements Range<double> {
  @override
  final double min;
  @override
  final double max;

  const LinearRange(this.min, this.max) : assert(min <= max);
  LinearRange.fromRectW(Rect r) : min = r.left, max = r.right;
  LinearRange.fromRectH(Rect r) : min = r.top, max = r.bottom;

  const LinearRange.all()
      : min = double.negativeInfinity,
        max = double.infinity;

  @override
  bool contains(double value) => min <= value && value <= max;

  @override
  double clamp(double value) => mmin(mmax(value, min), max);

  @override
  double distance(double value) => (value - clamp(value)).abs();
}

class LogarithmicRange implements Range<double> {
  @override
  final double min;
  @override
  final double max;

  const LogarithmicRange(this.min, this.max)
      : assert(min <= max),
        assert(min > 0);

  const LogarithmicRange.all() : min = 0, max = double.infinity;

  @override
  bool contains(double value) => min <= value && value <= max;

  @override
  double clamp(double value) => mmin(mmax(value, min), max);

  @override
  double distance(double value) => (value - clamp(value)).abs();
}

class AngularRange implements Range<double> {
  @override
  final double min;
  @override
  final double max;

  const AngularRange(min, max)
      : min = min % (2 * pi),
        max = max % (2 * pi);

  const AngularRange.all()
      : min = double.negativeInfinity,
        max = double.infinity;

  @override
  bool contains(double value) {
    final mid = (value - min) % (2 * pi);
    return min.isFinite && max.isFinite
        ? 0 <= mid && mid <= (max - min) % (2*pi)
        : true;
  }

  @override
  double clamp(double value) {
    if (contains(value)) return value;
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

  @override
  double distance(double value) => (value - clamp(value)).abs();
}
