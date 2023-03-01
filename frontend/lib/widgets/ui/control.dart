import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:frontend/constants.dart' as constants;
import 'package:frontend/widgets/ui/control_button.dart';

class ControlUI extends StatefulWidget {
  const ControlUI(
      {required this.playing,
      this.mouseActive = true,
      this.onBackwards,
      this.onPlayPause,
      this.onForwards,
      super.key});

  final VoidCallback? onBackwards;
  final VoidCallback? onPlayPause;
  final VoidCallback? onForwards;

  final bool playing;
  final bool mouseActive;

  @override
  State<ControlUI> createState() => _ControlUIState();
}

class _ControlUIState extends State<ControlUI> {
  _ControlUIState();

  bool get visible => widget.mouseActive || _hover;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          child: AnimatedContainer(
            transform: visible
                ? Matrix4.identity()
                : Matrix4.translationValues(0, 200, 0),
            duration: const Duration(milliseconds: 500),
            curve: !visible ? Curves.easeInBack : Curves.easeOutBack,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 500),
              scale: visible ? 1.0 : 0.7,
              curve: visible ? Curves.easeInBack : Curves.easeOutBack,
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x66000000),
                              blurRadius: 20,
                              offset: Offset(10, 15)),
                        ],
                        color: constants.transparentUiColour,
                        borderRadius: BorderRadius.circular(50)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ControlButton(
                          icon: FontAwesomeIcons.backward,
                          align: const FractionalOffset(0.4, 0.5),
                          onTap: widget.onBackwards,
                        ),
                        const SizedBox(width: 15),
                        ControlButton(
                          icon: widget.playing
                              ? FontAwesomeIcons.pause
                              : FontAwesomeIcons.play,
                          onTap: widget.onPlayPause,
                          align: widget.playing
                              ? Alignment.center
                              : const FractionalOffset(0.6, 0.5),
                        ),
                        const SizedBox(width: 15),
                        ControlButton(
                          icon: FontAwesomeIcons.forward,
                          align: const FractionalOffset(0.6, 0.5),
                          onTap: widget.onForwards,
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
