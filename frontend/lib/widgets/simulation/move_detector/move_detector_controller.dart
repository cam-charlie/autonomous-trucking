import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:frontend/utilities/animated_input_range.dart';
import 'package:frontend/utilities/camera_transform.dart';
import 'package:frontend/utilities/range.dart';
import 'package:frontend/utilities/velocity_calculator.dart';
import 'package:frontend/constants.dart' as constants;

/*
TODO:
  - [] add manual x, y, r, z, bounds, etc, changing
  - [] vehicle camera tracking?
  - [] make zoom and rotate about cursor
  - [] make parameters nicer
  - [] the rotate and zoom only gesture callbacks sometimes result in scuffed behaviour?
  - [] support onTap translated to world x-y
 */

typedef OffsetCallback = void Function(Offset);

class MoveDetectorAnimationOptions {
  final AnimatedInputRangeBoundOptions boundOptions;
  final AnimatedInputRangeSlowStopOptions slowStopOptions;

  const MoveDetectorAnimationOptions(
      {required this.boundOptions, required this.slowStopOptions});
}

class MoveDetectorController extends ChangeNotifier {
  CameraTransform get transform =>
      CameraTransform(position: pan, zoom: zoom, rotation: rotation);

  Offset get pan => Offset(_xController.x, _yController.x);

  double get zoom => _zController.x;

  double get rotation => _rController.x;

  late final AnimatedInputRange _xController;
  late final AnimatedInputRange _yController;
  late final AnimatedInputRange _zController;
  late final AnimatedInputRange _rController;

  final OffsetCallback? onTap;

  MoveDetectorController({
    required TickerProvider tickerProvider,
    required CameraTransform initialTransform,
    Rect panBounds = const Rect.fromLTRB(double.negativeInfinity,
        double.infinity, double.infinity, double.negativeInfinity),
    LogarithmicRange zoomBounds = const LogarithmicRange.all(),
    AngularRange rotationBounds = const AngularRange.all(),
    MoveDetectorAnimationOptions? panAnimations,
    MoveDetectorAnimationOptions? zoomAnimations,
    MoveDetectorAnimationOptions? rotateAnimations,
    this.onTap,
  }) {
    _xController = AnimatedInputRange(
      initialValue: initialTransform.position.dx,
      vsync: tickerProvider,
      slowStopOptions: panAnimations!.slowStopOptions,
      boundOptions: panAnimations!.boundOptions,
      bounds: LinearRange.fromRectW(panBounds),
      debug: true,
    )..addListener(notifyListeners);
    _yController = AnimatedInputRange(
      initialValue: initialTransform.position.dy,
      vsync: tickerProvider,
      slowStopOptions: panAnimations!.slowStopOptions,
      boundOptions: panAnimations!.boundOptions,
      bounds: LinearRange.fromRectH(panBounds),
    )..addListener(notifyListeners);
    _zController = AnimatedInputRange(
      initialValue: initialTransform.zoom,
      vsync: tickerProvider,
      slowStopOptions: zoomAnimations!.slowStopOptions,
      boundOptions: zoomAnimations!.boundOptions,
      bounds: zoomBounds,
    )..addListener(notifyListeners);
    _rController = AnimatedInputRange(
      initialValue: initialTransform.rotation,
      vsync: tickerProvider,
      slowStopOptions: rotateAnimations!.slowStopOptions,
      boundOptions: rotateAnimations!.boundOptions,
    )..addListener(notifyListeners);
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    _rController.dispose();
    super.dispose();
  }

  Offset transformPanWithRotationAndZoom(Offset pan) {
    final s = sin(rotation), c = cos(rotation); // TODO: need the "-"?
    return Offset(
      -(c * pan.dx + s * pan.dy) / zoom,
      -(-s * pan.dx + c * pan.dy) / zoom,
    );
  }

  scaleStart(ScaleStartDetails details) {
    _xController.onStart();
    _yController.onStart();
    _zController.onStart();
    _rController.onStart();
  }

  scaleUpdate(ScaleUpdateDetails details) {
    /*
    TODO make rotate and zoom about focal point
      - get focal point
      - convert focal point into world coordinate
      - rotate and zoom about world-coordinate focal point

     */


    _zController.onUpdate(
        details.scale, (double b, double c, double n) => b * n);

    _rController.onUpdate(
        details.rotation, (double b, double c, double n) => (b + n) % (2 * pi));

    /*
    TODO since the focal point changes each update, we need the delta r and z?
      - and not just the input delta r and z, but the applied (post animated input range)
      - and what about when its animating the r&z and there is then no focal point?
      - in this case we also can't just continually animate the pan after rotation, as the rotation animation was non-linear
      - the r&z animation need to affect the pan animation (change them, but not stop their animation)

    TODO
      - we need some way of defining a rotation about another point as a corresponding change in pan and rotation
      - as if your 'looking point' origin is not always in the centre of the screen?
      -
      - we need to change the way we think about what our x, y, r, z values mean
      - currently the purpose is to make the job of rendering as easy as possible
        - we tell it what point should be shown in the centre,
            what zoom level ABOUT THE LOOKING POINT,
            and what rotation ABOUT THE LOOKING POINT it should be
      - these decisions are somewhat arbitrary, but chosen to make life for the renderer as easy as possible
      - the reason having zoom and rotation be about the LOOKING POINT is so easy
          is because neither the renderer nor the MoveDetector has to do any work.
          It simply applies the transformations after moving to the correct position.
          - And you can't just move the problem to the renderer by asking it to move instead to the rotation origin,
              then rotate, and then move to the actual pan position, because as soon as you have a second, different
              rotation origin, then you need to calculate the actual current pan position.
      - so is the only solution to allow the rotation and zoom controllers to affect the pan controllers?
      - it would kinda suck? maybe not
        - you would need to be able to add onto the pan controllers current values without affecting any
            currently happening input (e.g. doesn't affect velocity). the input state machine would not notice
            any difference. i think this should be okay as long as the _baseX etc variables are updated..?
      - the pan controllers could be seen as rotating around the outside of a wheel. so you simply calculate
          their initial radius and angle, and adjust the angle as needed, generating the new coordinates.
        - now how do you do that in conjunction with zoom?
      - what if, when the r&z controllers need to adjust the pan controller, that the pan controller hits a boundary?
        - the pan controller would need to return how much it was able to move by, and the r&z controllers
            would need to listen to that and ensure they only change by however much was allowed.
          - perhaps its allowed to rotate whatever it likes, and when the gesture is finished then the bound animation
              plays and brings the user back into bounds?
          - what about the hard bounds? i think it would make more sense for the rotation and zoom to need to listen
              and adjust. but honestly just having the pan controllers animate back into bounds after the gesture is over
              might be fine.
          - its not like content outside of the hard bound is not allowed to be seen, as the hard bound is just
              for the middle of the screen
     */



    final Offset translatedPan =
        transformPanWithRotationAndZoom(details.focalPointDelta);
    _xController.onUpdate(
        translatedPan.dx, (double b, double c, double n) => c + n);
    _yController.onUpdate(
        translatedPan.dy, (double b, double c, double n) => c + n);
  }

  scaleEnd(ScaleEndDetails details) {
    final translatedVelocity =
        transformPanWithRotationAndZoom(details.velocity.pixelsPerSecond);
    _xController.onEnd(translatedVelocity.dx);
    _yController.onEnd(translatedVelocity.dy);
    _zController.onEnd();
    _rController.onEnd();

    // TODO: prevent back swing animation
  }

  Offset _canvasToWorld(Offset canvasPosition, Size size) {
    /* TODO:
        - first unzoom and unrotate. those two are independent because
          they happen about the same point, and so can be done in either order
        - then subtract the x-y offset

      TODO
        - if the user taps in the middle of the screen, they tapped on the current
          x-y coordinates. so you need to find the offset from the centre of the screen
        1. first calculate the difference between the local tap coords and the screen centre
        2. then scale and rotate that difference based on the room and rotation
        3.
     */

    final Offset centre = Offset(size.width/2, size.height/2);
    final double s = sin(-rotation), c = cos(-rotation);
    Offset diff = centre - canvasPosition;
    diff = Offset(
      c*diff.dx + s*diff.dy,
      -s*diff.dx + c*diff.dy,
    );
    diff /= zoom;
    return pan - diff;
  }

  tap(TapUpDetails details, Size size) {
    final worldCoords = _canvasToWorld(details.localPosition, size);
    onTap?.call(worldCoords);
  }
}
