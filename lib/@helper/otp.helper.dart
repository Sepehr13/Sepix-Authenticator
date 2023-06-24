import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:otp/otp.dart';

import '../@types/Entity.type.dart';

class OTPHelper {
  final BuildContext context;

  OTPHelper(this.context);

  static OTPHelper of(BuildContext context) {
    return OTPHelper(context);
  }

  Future<void> generateHOTPCode(Entity entity) {
    Completer<void> completer = Completer<void>();
    entity.count = entity.count! + 1;
    final newOTP =
        OTP.generateHOTPCodeString(entity.code, entity.count!, isGoogle: true);
    entity.lastHOTPCode = '${newOTP.substring(0, 3)} ${newOTP.substring(3, 6)}';
    entity.save();
    completer.complete();
    return completer.future;
  }

  String generateTOTPCode(Entity entity) {
    final now = DateTime.now();
    final otp = OTP.generateTOTPCodeString(
        entity.code, now.millisecondsSinceEpoch,
        isGoogle: true, algorithm: Algorithm.SHA1);
    return '${otp.substring(0, 3)} ${otp.substring(3, 6)}';
  }

  void copyToClipboard(Entity entity) {
    String code = '';
    if (entity.type == 'TOTP') {
      code = generateTOTPCode(entity).replaceAll(' ', '');
    } else {
      code = entity.lastHOTPCode.replaceAll(' ', '');
    }
    Clipboard.setData(ClipboardData(text: code)).then((_) => {
          if (context.mounted) {EasyLoading.showSuccess('Copied!')}
        });
  }
}
