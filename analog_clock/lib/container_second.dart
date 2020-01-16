// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'hand.dart';

/// A clock hand that is built out of the child of a [Container].
///
/// This hand does not scale according to the clock's size.
/// This hand is used as the hour hand in our analog clock, and demonstrates
/// building a hand using existing Flutter widgets.
class ContainerSecond extends Hand {
  /// Create a const clock [Hand].
  ///
  /// All of the parameters are required and must not be null.
  const ContainerSecond({
    @required Color color,
    @required double angleRadians,
    this.child,
  })  : assert(angleRadians != null),
        super(
        color: color,
        angleRadians: angleRadians,
      );

  /// The child widget used as the clock hand and rotated by [angleRadians].
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Transform.rotate(
        angle: angleRadians,
        child: Container(
          color: color,
          child: Center(child: child),
        ),
      ),
    );
  }
}
