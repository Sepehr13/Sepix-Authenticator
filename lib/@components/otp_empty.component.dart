// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OTPEmpty extends StatelessWidget {
  const OTPEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverSafeArea(
      top: false,
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.clear_circled,
                  color: Colors.grey.withOpacity(0.4),
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  'The list is empty.',
                  style: TextStyle(
                      fontSize: 20, color: Colors.grey.withOpacity(0.4)),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }
}
