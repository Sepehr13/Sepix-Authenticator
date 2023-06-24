// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:otp/otp.dart';

import '../@helper/otp.helper.dart';
import '../@types/Entity.type.dart';

class OTPCard extends StatefulWidget {
  final Entity entity;
  final int dangerTime;
  final Function(Entity) onLongPress;
  final Function() onRefresh;
  const OTPCard(
      {super.key,
      required this.entity,
      required this.dangerTime,
      required this.onLongPress,
      required this.onRefresh});

  @override
  State<OTPCard> createState() => _OTPCardState();
}

class _OTPCardState extends State<OTPCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: () {
          OTPHelper.of(context).copyToClipboard(widget.entity);
        },
        onLongPress: () {
          widget.onLongPress(widget.entity);
        },
        child: SizedBox(
          width: double.infinity,
          height: 100,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
                border: Border.all(
                    color: CupertinoColors.systemGrey.withOpacity(0.4)),
                borderRadius: BorderRadius.circular(20)),
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            '${widget.entity.issuer} (${widget.entity.title})',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16,
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.dark
                                        ? CupertinoColors.white
                                        : CupertinoColors.black),
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          widget.entity.type == 'TOTP'
                              ? OTPHelper.of(context)
                                  .generateTOTPCode(widget.entity)
                              : widget.entity.lastHOTPCode,
                          style: TextStyle(
                            fontSize: 32,
                            color: OTP.remainingSeconds() < widget.dangerTime &&
                                    widget.entity.type == 'TOTP'
                                ? CupertinoColors.destructiveRed
                                    .withOpacity(0.8)
                                : CupertinoColors.activeBlue.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: widget.entity.type == 'TOTP'
                          ? SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                color:
                                    OTP.remainingSeconds() < widget.dangerTime
                                        ? CupertinoColors.destructiveRed
                                            .withOpacity(0.8)
                                        : CupertinoColors.activeBlue
                                            .withOpacity(0.8),
                                value: OTP.remainingSeconds() / 30,
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                await OTPHelper.of(context)
                                    .generateHOTPCode(widget.entity);
                                widget.onRefresh();
                              },
                              child: Icon(
                                CupertinoIcons.arrow_clockwise,
                                color:
                                    CupertinoColors.activeBlue.withOpacity(0.8),
                                size: 30,
                              ),
                            ),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
