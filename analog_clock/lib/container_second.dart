// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';

import 'hand.dart';

/// A clock hand that is built out of the child of a [Container].
///
/// This hand does not scale according to the clock's size.
/// This hand is used as the hour hand in our analog clock, and demonstrates
/// building a hand using existing Flutter widgets.
class ContainerSecond extends StatelessWidget {
  /// Create a const clock [Hand].

  /// All of the parameters are required and must not be null.
  const ContainerSecond({
    this.color,
    this.angleRadians,
    this.child,
  })  : assert(angleRadians != null),
        assert(color != null);

  /// The child widget used as the clock hand and rotated by [angleRadians].
  final Widget child;
  final Color color;
  final double angleRadians;

  @override
  Widget build(BuildContext context) {
    return Animator(
      tween: Tween<double>(begin: angleRadians, end: angleRadians + (2 * pi)),
      duration: Duration(seconds: 60),
      repeats: 0,
      builder: (anim) => Center(
        child: SizedBox.expand(
          child: Transform.rotate(
            angle: anim.value,
            child: Container(
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }

//  @override
//  Widget build(BuildContext context) {
//    return SizedBox.expand(
//      child: Transform.rotate(
//        angle: angleRadians,
//        child: Container(
//          color: color,
//          child: Center(child: child),
//        ),
//      ),
//    );
//  }

}
