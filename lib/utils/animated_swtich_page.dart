import 'package:flutter/material.dart';

enum RouteAnimation {
  slideRight,
  slideLeft,
  slideTop,
  slideBottom,
  scale,
  fade,
}

const List<RouteAnimation> slideAnimations = [
  RouteAnimation.slideBottom,
  RouteAnimation.slideLeft,
  RouteAnimation.slideRight,
  RouteAnimation.slideTop
];

animatedSwitchPage(
  BuildContext context,
  Widget page, {
  RouteAnimation routeAnimation = RouteAnimation.fade,
  bool withBack = true,
  bool clearNavigator = false,
}) {
  final route = PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      if (slideAnimations.contains(routeAnimation)) {
        final Offset begin;
        switch (routeAnimation) {
          case RouteAnimation.slideRight:
            begin = const Offset(-1.0, 0.0);
            break;
          case RouteAnimation.slideLeft:
            begin = const Offset(1.0, 0.0);
            break;
          case RouteAnimation.slideTop:
            begin = const Offset(0.0, 1.0);
            break;
          case RouteAnimation.slideBottom:
            begin = const Offset(0.0, -1.0);
            break;
          default:
            begin = const Offset(-1.0, 0.0);
            break;
        }
        const end = Offset.zero;
        const curve = Curves.ease;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      } else if (routeAnimation == RouteAnimation.fade) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      } else {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      }
    },
  );
  if (!clearNavigator) {
    withBack
        ? Navigator.of(context).push(route)
        : Navigator.of(context).pushReplacement(route);
  } else {
    Navigator.of(context).pushAndRemoveUntil(route, (r) => false);
  }
}
