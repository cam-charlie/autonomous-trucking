import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/widgets/ui/gradient_icon.dart';

class ControlButton extends StatefulWidget {
  const ControlButton({required this.icon, this.align, this.onTap, super.key});
  final IconData icon;
  final AlignmentGeometry? align;
  final VoidCallback? onTap;


  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  bool hover = false;
  bool down = false;
  double get scale => down ? 0.8 : hover ? 1.2 : 1;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => down = true),
        onTapCancel: () => setState(() => down = false),
        onTapUp: (_) => setState(() => down = false),
        onTap: widget.onTap,
        behavior: HitTestBehavior.translucent,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 400),
          scale: scale,
          curve: Curves.elasticOut,
          child: Opacity(
            opacity: 0.9,
            child: Container(
              width: 56,
              height: 56,
              // margin: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff878E83),
                    Color(0xff5C6357),
                  ],
                ),
              ),
              child: Align(
                alignment: widget.align ?? Alignment.center,
                child: GradientIcon(
                  icon: widget.icon,
                  size: 32,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xffFFFFFF),
                      Color(0x10FFFFFF),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
