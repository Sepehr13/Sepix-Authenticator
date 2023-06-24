// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_local_variable, avoid_single_cascade_in_expression_statements, unused_element

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:otp/otp.dart';
import 'package:shimmer/shimmer.dart';

import '../@types/Entity.type.dart';

class AddManuallyWidget extends StatefulWidget {
  final Function(Entity) onNewEntity;
  const AddManuallyWidget({super.key, required this.onNewEntity});

  @override
  State<AddManuallyWidget> createState() => _AddManuallyWidgetState();
}

class _AddManuallyWidgetState extends State<AddManuallyWidget> {
  TextEditingController _secretController = TextEditingController(text: '');
  TextEditingController _nameController = TextEditingController(text: '');
  TextEditingController _issuerController = TextEditingController(text: '');
  TextEditingController _countController = TextEditingController(text: '');
  String _selectedMode = 'TOTP';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: 400,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          color: MediaQuery.of(context).platformBrightness == Brightness.dark
              ? CupertinoTheme.of(context).barBackgroundColor
              : CupertinoTheme.of(context).scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CupertinoTextField(
                  controller: _nameController,
                  placeholder: 'Account Name',
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                CupertinoTextField(
                  controller: _secretController,
                  placeholder: 'Secret Key (Base32)',
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                CupertinoTextField(
                  controller: _issuerController,
                  placeholder: 'Issuer',
                  onChanged: (_) {
                    setState(() {});
                  },
                ),
                _selectedMode == 'HOTP'
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 16,
                          ),
                          CupertinoTextField(
                            controller: _countController,
                            placeholder: 'Count (default is 0)',
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            onChanged: (_) {
                              setState(() {});
                            },
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CupertinoSlidingSegmentedControl<String>(
                  backgroundColor: CupertinoColors.systemGrey2,
                  thumbColor: CupertinoColors.white,
                  groupValue: _selectedMode,
                  onValueChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _selectedMode = value;
                      });
                    }
                  },
                  children: const <String, Widget>{
                    'TOTP': Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Time Based',
                        style: TextStyle(color: CupertinoColors.black),
                      ),
                    ),
                    'HOTP': Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Counter Based',
                        style: TextStyle(color: CupertinoColors.black),
                      ),
                    ),
                  },
                ),
                SizedBox(
                  height: 22,
                ),
                CupertinoButton.filled(
                    onPressed: _nameController.text.isNotEmpty &&
                            _secretController.text.isNotEmpty &&
                            _issuerController.text.isNotEmpty
                        ? () {
                            var entity = Entity()
                              ..title = _nameController.text.trim()
                              ..code = _secretController.text.trim()
                              ..issuer = _issuerController.text.trim()
                              ..count = _countController.text.trim().isEmpty
                                  ? 0
                                  : int.parse(_countController.text.trim())
                              ..lastHOTPCode = _selectedMode == 'HOTP'
                                  ? OTP.generateHOTPCodeString(
                                      _secretController.text.trim(),
                                      _countController.text.trim().isEmpty
                                          ? 0
                                          : int.parse(
                                              _countController.text.trim()))
                                  : ''
                              ..type = _selectedMode;
                            widget.onNewEntity(entity);
                            Navigator.pop(context);
                          }
                        : null,
                    child: Text(
                      'Add To List',
                      style: TextStyle(color: CupertinoColors.white),
                    )),
                SizedBox(
                  height: 8,
                ),
                CupertinoButton(
                    onPressed: () {
                      SchedulerBinding.instance.addPostFrameCallback((_) {
                        _nameController.clear();
                        _secretController.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                        setState(() {
                          _selectedMode = 'TOTP';
                        });
                        Navigator.pop(context);
                      });
                    },
                    child: Text(
                      'Dismiss',
                      style: TextStyle(color: CupertinoColors.destructiveRed),
                    )),
              ],
            )
          ],
        ),
      ),
    );
    ;
  }
}
