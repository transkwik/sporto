import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

/// Row of individually boxed OTP digit fields with auto-advance-on-type and
/// auto-back-on-delete focus behaviour, styled to match the dark
/// glassmorphism auth screens. Whichever box is currently focused brightens
/// into a frosted glass highlight with a soft ambient white glow.
class OtpInputRow extends StatefulWidget {
  const OtpInputRow({super.key, required this.length, this.onChanged, this.onCompleted});

  final int length;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onCompleted;

  @override
  State<OtpInputRow> createState() => OtpInputRowState();
}

class OtpInputRowState extends State<OtpInputRow> {
  late final List<TextEditingController> _controllers = List.generate(
    widget.length,
    (_) => TextEditingController(),
  );
  late final List<FocusNode> _focusNodes = List.generate(widget.length, (_) => FocusNode());
  late final List<bool> _isFocused = List.generate(widget.length, (_) => false);

  String get _code => _controllers.map((c) => c.text).join();

  void clear() {
    for (final controller in _controllers) {
      controller.clear();
    }
    _focusNodes.first.requestFocus();
    widget.onChanged?.call('');
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.length; i++) {
      _focusNodes[i].addListener(() => _handleFocusChanged(i));
    }
  }

  void _handleFocusChanged(int index) {
    final hasFocus = _focusNodes[index].hasFocus;
    if (_isFocused[index] != hasFocus) {
      setState(() => _isFocused[index] = hasFocus);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _handleChanged(int index, String value) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    widget.onChanged?.call(_code);
    if (_code.length == widget.length) {
      widget.onCompleted?.call(_code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        final bool isFocused = _isFocused[index];
        return SizedBox(
          width: 64,
          height: 64,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: isFocused ? Colors.white.withValues(alpha: 0.16) : AppColors.glassFillLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isFocused ? Colors.white.withValues(alpha: 0.55) : AppColors.glassBorderStrong,
                width: isFocused ? 1.4 : 1,
              ),
              boxShadow: isFocused
                  ? [
                      BoxShadow(color: Colors.white.withValues(alpha: 0.22), blurRadius: 22, spreadRadius: 1),
                    ]
                  : [],
            ),
            child: Focus(
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.backspace &&
                    _controllers[index].text.isEmpty &&
                    index > 0) {
                  _focusNodes[index - 1].requestFocus();
                  return KeyEventResult.handled;
                }
                return KeyEventResult.ignored;
              },
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                autofocus: index == 0,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
                cursorColor: AppColors.primaryLight,
                decoration: const InputDecoration(
                  counterText: '',
                  filled: false,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onChanged: (value) => _handleChanged(index, value),
              ),
            ),
          ),
        );
      }),
    );
  }
}
