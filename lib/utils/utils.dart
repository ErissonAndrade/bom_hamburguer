import 'package:flutter/material.dart';

const snackBarBackgroundColor = Colors.white;
const snackBarTextStyle = TextStyle(fontSize: 16, color: Colors.red);

const confirmDialogMessageStyle = TextStyle(fontSize: 18);
const confirmDialogBtnTextStyle = TextStyle(fontSize: 16, color: Colors.white);

class Utils {
  static void checkAndCloseSnackbar(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (scaffoldMessenger.mounted) {
      scaffoldMessenger.hideCurrentSnackBar();
    }
  }

  static showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: snackBarTextStyle,
        ),
        backgroundColor: snackBarBackgroundColor,
      ),
    );
  }

  static Future<bool?> showConfirmDialog(BuildContext context, String message) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          title: const Center(child: Text('Confirm')),
          content: Text(message,
              style: confirmDialogMessageStyle, textAlign: TextAlign.center),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Yes',
                style: confirmDialogBtnTextStyle,
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: const Text(
                'No',
                style: confirmDialogBtnTextStyle,
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }
}
