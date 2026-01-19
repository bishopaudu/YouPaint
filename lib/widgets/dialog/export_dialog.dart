// ==================== widgets/dialogs/export_dialog.dart ====================
import 'package:flutter/material.dart';

class ExportDialog extends StatefulWidget {
  final Function(String filename, bool isVideo) onExport;

  const ExportDialog({Key? key, required this.onExport}) : super(key: key);

  @override
  State<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<ExportDialog> {
  final TextEditingController _filenameController = TextEditingController();
  bool _isVideo = false;

  @override
  void initState() {
    super.initState();
    _filenameController.text =
        "drawing_${DateTime.now().millisecondsSinceEpoch}";
  }

  @override
  void dispose() {
    _filenameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.save_alt, color: Color(0xFF667EEA)),
          SizedBox(width: 12),
          Text("Export Drawing"),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Filename",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF636E72),
            ),
          ),
          SizedBox(height: 8),
          TextField(
            controller: _filenameController,
            decoration: InputDecoration(
              hintText: "Enter filename",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Export Format",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF636E72),
            ),
          ),
          SizedBox(height: 12),
          _buildFormatOption(
            icon: Icons.image,
            label: "PNG Image",
            subtitle: "Save as static image",
            isSelected: !_isVideo,
            onTap: () => setState(() => _isVideo = false),
          ),
          SizedBox(height: 8),
          _buildFormatOption(
            icon: Icons.videocam,
            label: "MP4 Video",
            subtitle: "Save replay as video",
            isSelected: _isVideo,
            onTap: () => setState(() => _isVideo = true),
          ),
        ],
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
            if (_filenameController.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please enter a filename")),
              );
              return;
            }
            widget.onExport(_filenameController.text.trim(), _isVideo);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF667EEA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text("Export", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _buildFormatOption({
    required IconData icon,
    required String label,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF667EEA).withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Color(0xFF667EEA) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Color(0xFF667EEA) : Colors.grey[600],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Color(0xFF667EEA) : Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Color(0xFF667EEA)),
          ],
        ),
      ),
    );
  }
}