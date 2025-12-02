import 'package:flutter/material.dart';
import 'package:el_impostor_app/core/constants/app_animations.dart';

/// Transición con fade y slide
class FadeSlideTransition extends PageRouteBuilder {
  final Widget page;

  FadeSlideTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AppAnimations.pageTransition,
          reverseTransitionDuration: AppAnimations.pageTransition,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 0.3);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var slideTween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));
            var fadeTween = Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(slideTween),
              child: FadeTransition(
                opacity: animation.drive(fadeTween),
                child: child,
              ),
            );
          },
        );
}

/// Transición con escala y rotación
class ScaleRotateTransition extends PageRouteBuilder {
  final Widget page;

  ScaleRotateTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AppAnimations.pageTransition,
          reverseTransitionDuration: AppAnimations.pageTransition,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOutCubic;

            var scaleTween = Tween<double>(begin: 0.8, end: 1.0)
                .chain(CurveTween(curve: curve));
            var rotateTween = Tween<double>(begin: -0.1, end: 0.0)
                .chain(CurveTween(curve: curve));
            var fadeTween = Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: curve));

            return ScaleTransition(
              scale: animation.drive(scaleTween),
              child: RotationTransition(
                turns: animation.drive(rotateTween),
                child: FadeTransition(
                  opacity: animation.drive(fadeTween),
                  child: child,
                ),
              ),
            );
          },
        );
}

/// Transición tipo flip de carta
class CardFlipTransition extends PageRouteBuilder {
  final Widget page;

  CardFlipTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AppAnimations.cardFlip,
          reverseTransitionDuration: AppAnimations.cardFlip,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOutCubic;

            var rotationTween = Tween<double>(begin: 1.5708, end: 0.0) // 90 grados
                .chain(CurveTween(curve: curve));

            return AnimatedBuilder(
              animation: animation,
              builder: (context, child) {
                final angle = rotationTween.evaluate(animation);
                final transform = Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateY(angle);

                return Transform(
                  transform: transform,
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: child,
            );
          },
        );
}

/// Transición desde abajo (modal style)
class SlideFromBottomTransition extends PageRouteBuilder {
  final Widget page;

  SlideFromBottomTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AppAnimations.pageTransition,
          reverseTransitionDuration: AppAnimations.pageTransition,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOutCubic;

            var slideTween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(slideTween),
              child: child,
            );
          },
        );
}

/// Transición con zoom dramático
class ZoomTransition extends PageRouteBuilder {
  final Widget page;

  ZoomTransition({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: AppAnimations.medium,
          reverseTransitionDuration: AppAnimations.medium,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const curve = Curves.easeInOutQuart;

            var scaleTween = Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: curve));
            var fadeTween = Tween<double>(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: curve));

            return ScaleTransition(
              scale: animation.drive(scaleTween),
              child: FadeTransition(
                opacity: animation.drive(fadeTween),
                child: child,
              ),
            );
          },
        );
}
