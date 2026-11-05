import 'package:flutter/material.dart';
import 'package:dwaay/config/constant.dart';
import 'package:dwaay/config/global.dart';
import 'package:dwaay/utils/widgets/custom_toast.dart';

class AuthGuard {
  /// Ensure the user is logged in. If not, show a toast and navigate to login.
  /// Returns true if the user is already logged in.
  static Future<bool> ensureLoggedIn(BuildContext context) async {
    if (Global.userData != null && Global.userData!.token.isNotEmpty) {
      return true;
    }

    // Show toast message with authGuard type (includes Sign In button)
    ToastManager.show(
      context: context,
      type: ToastType.authGuard,
      fontSize: 14,
      message: AppConstant.authMessage,
      fromAuthGuard: true,
    );

    return false;
  }
}
