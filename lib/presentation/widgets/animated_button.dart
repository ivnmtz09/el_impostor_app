import 'package:flutter/material.dart';
import 'package:el_impostor_app/core/constants/app_colors.dart';
import 'package:el_impostor_app/core/constants/app_animations.dart';
import 'package:el_impostor_app/core/services/feedback_service.dart';

enum AnimatedButtonVariant { primary, secondary, danger, success }

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final AnimatedButtonVariant variant;
  final IconData? icon;
  final bool isLoading;
  final bool enabled;
  final double? width;
  final double? height;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AnimatedButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.enabled = true,
    this.width,
    this.height,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppAnimations.buttonPress,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: AppAnimations.buttonPressScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBackgroundColor() {
    switch (widget.variant) {
      case AnimatedButtonVariant.primary:
        return AppColors.acentoCTA;
      case AnimatedButtonVariant.secondary:
        return AppColors.acentoSecundario;
      case AnimatedButtonVariant.danger:
        return Colors.red[600]!;
      case AnimatedButtonVariant.success:
        return Colors.green[600]!;
    }
  }

  Color _getTextColor() {
    return AppColors.textoBoton;
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enabled || widget.isLoading) return;
    setState(() => _isPressed = true);
    _controller.forward();
    FeedbackService.lightVibration();
    FeedbackService.playButtonTap();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enabled || widget.isLoading) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    if (!widget.enabled || widget.isLoading) return;
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor();
    final textColor = _getTextColor();

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.enabled && !widget.isLoading ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: AppAnimations.fast,
              width: widget.width,
              height: widget.height ?? 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: widget.enabled
                      ? [
                          backgroundColor,
                          backgroundColor.withOpacity(0.8),
                        ]
                      : [Colors.grey, Colors.grey.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (widget.enabled ? backgroundColor : Colors.grey)
                        .withOpacity(_isPressed ? 0.2 : 0.4),
                    blurRadius: _isPressed ? 4 : 8,
                    offset: Offset(0, _isPressed ? 2 : 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: widget.enabled && !widget.isLoading
                      ? widget.onPressed
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.isLoading)
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(textColor),
                            ),
                          )
                        else if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            color: textColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                        ],
                        Text(
                          widget.text,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
