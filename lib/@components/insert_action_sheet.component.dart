// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields, unused_local_variable, avoid_single_cascade_in_expression_statements, unused_element, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:otp/otp.dart';

import '../@pages/scanner.dart';
import '../@types/Entity.type.dart';
import 'add_manually.component.dart';

class InsertActionSheet extends StatelessWidget {
  final Function(Entity) onNewEntity;
  const InsertActionSheet({super.key, required this.onNewEntity});

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      actions: <CupertinoActionSheetAction>[
        CupertinoActionSheetAction(
          onPressed: () async {
            Navigator.of(context).pop();
            var result = await Navigator.of(context)
                .push(CupertinoPageRoute(builder: (_) => ScannerPage()));
            if (result is String) {
              // otpauth://totp/TTT?secret=KNCVARKIKJQXU2L2NEYTGCQ&issuer=Apple
              if (!result.startsWith("otpauth://")) {
                if (context.mounted) {
                  EasyLoading.showError('Invalid 2FA Token');
                }
                return;
              }
              result = result.replaceAll('otpauth://', '');
              result = result.split('/');
              String type = (result[0] as String).toUpperCase();
              result = (result[1] as String).split('?');
              String title = result[0];
              String? secret;
              String? issuer;
              String? counter;
              (result[1] as String).split('&').forEach((e) {
                List element = e.split('=');
                if (element.length > 2) {
                  if (context.mounted) {
                    EasyLoading.showError('Invalid Token Secret/Issuer');
                  }
                  return;
                }
                if (element[0] == 'secret') {
                  secret = element[1];
                }
                if (element[0] == 'issuer') {
                  issuer = element[1];
                }
                if (element[0] == 'counter') {
                  counter = element[1];
                }
              });
              if (secret != null && issuer != null) {
                var entity = Entity()
                  ..title = title
                  ..code = secret!
                  ..issuer = issuer!
                  ..count = counter == null ? 0 : int.parse(counter!.trim())
                  ..lastHOTPCode = type == 'HOTP'
                      ? OTP.generateHOTPCodeString(
                          secret!.trim(),
                          counter!.trim().isEmpty
                              ? 0
                              : int.parse(counter!.trim()))
                      : ''
                  ..type = type;
                onNewEntity(entity);
              } else {
                if (context.mounted) {
                  EasyLoading.showError('Error Retrieving Token Secret/Issuer');
                }
                return;
              }
            }
          },
          child: const Text('Scan QR Code'),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
            showCupertinoModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(18))),
                builder: (ctx) => AddManuallyWidget(
                    context: ctx,
                    onNewEntity: (entity) {
                      onNewEntity(entity);
                    })).whenComplete(() {
              FocusManager.instance.primaryFocus?.unfocus();
            });
          },
          child: const Text('Manual Input'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Close'),
      ),
    );
  }
}
