import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BigBlueButton extends ImplicitlyAnimatedWidget {
  const BigBlueButton(
      {Key? key,
      required this.icon,
      required this.text,
      this.focusNode,
      this.onTap})
      : super(
          key: key,
          curve: Curves.easeInOutCirc,
          duration: const Duration(milliseconds: 250),
        );

  final Widget icon;
  final Widget text;
  final FocusNode? focusNode;
  final void Function()? onTap;

  @override
  AnimatedWidgetBaseState<BigBlueButton> createState() => _BigBlueButtonState();
}

class _BigBlueButtonState extends AnimatedWidgetBaseState<BigBlueButton> {
  ColorTween? _colorTween;
  Tween<double>? _iconScaleTween;
  Tween<double>? _buttonScaleTween;

  bool _focused = false;

  bool _pressed = false;

  bool _hovered = false;

  bool get _enabled => widget.onTap != null;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (event) {
        _hovered = true;
        didUpdateWidget(widget);
      },
      onExit: (event) {
        _hovered = false;
        didUpdateWidget(widget);
      },
      child: Focus(
        focusNode: widget.focusNode,
        onFocusChange: (focused) {
          _focused = focused;
          didUpdateWidget(widget);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 48,
              width: 80,
              child: Padding(
                padding: EdgeInsets.all(_buttonScaleTween!.evaluate(animation)),
                child: PhysicalShape(
                  color: _colorTween!.evaluate(animation)!,
                  elevation: _focused ? 2 : 0,
                  clipper: ShapeBorderClipper(
                    shape: const StadiumBorder(),
                    textDirection: Directionality.maybeOf(context),
                  ),
                  child: GestureDetector(
                    onTap: widget.onTap,
                    onTapDown: (_) {
                      if (!_enabled) return;
                      _pressed = true;
                      didUpdateWidget(widget);
                    },
                    onTapUp: (_) {
                      _pressed = false;
                      didUpdateWidget(widget);
                    },
                    onTapCancel: () {
                      _pressed = false;
                      didUpdateWidget(widget);
                    },
                    behavior: HitTestBehavior.opaque,
                    excludeFromSemantics: true,
                    child: IconTheme(
                      data: const IconThemeData(color: Color(0xffffffff)),
                      child: ScaleTransition(
                        scale: _iconScaleTween!.animate(animation),
                        child: widget.icon,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: _colorTween!.evaluate(animation)!,
                  fontSize: 10,
                  // TODO add Inter font?
                  fontWeight: FontWeight.w400,
                ),
                child: widget.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _colorTween = visitor(
      _colorTween,
      () {
        if (_hovered) {
          return _pressed ? Color(0xFF561A23) : Color(0xFF1A5623);
        } else {
          return _pressed ? Color(0xFF561ADB) : Color(0xFF1A56DB);
        }
      }(),
      (dynamic value) => ColorTween(begin: value as Color?),
    ) as ColorTween?;
    _iconScaleTween = visitor(
      _iconScaleTween,
      _pressed ? 1.1 : 1.0,
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double>?;
    _buttonScaleTween = visitor(
      _buttonScaleTween,
      _pressed ? 2.0 : 0.0,
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double>?;
  }
}