// ==================== widgets/dialogs/clear_confirmation_dialog.dart ====================
import 'package:flutter/material.dart';

class ClearConfirmationDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const ClearConfirmationDialog({Key? key, required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange),
          SizedBox(width: 12),
          Text("Clear Canvas?"),
        ],
      ),
      content: Text(
        "This will delete your current drawing. This action cannot be undone.",
        style: TextStyle(color: Color(0xFF636E72)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: TextStyle(color: Color(0xFF636E72)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text("Clear", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}