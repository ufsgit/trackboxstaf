import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionHandler extends StatefulWidget {
  final Widget child;
  final ValueChanged<bool>? onPermissionChanged;

  const NotificationPermissionHandler({
    Key? key,
    required this.child,
    this.onPermissionChanged,
  }) : super(key: key);

  @override
  _NotificationPermissionHandlerState createState() =>
      _NotificationPermissionHandlerState();
}

class _NotificationPermissionHandlerState
    extends State<NotificationPermissionHandler> {
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationPermission();
  }

  Future<void> _checkNotificationPermission() async {
    var status = await Permission.notification.status;
    var isGranted = status == PermissionStatus.granted;
    setState(() {
      _isPermissionGranted = isGranted;
    });
    if (widget.onPermissionChanged != null) {
      widget.onPermissionChanged!(isGranted);
    }
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.request();
    var isGranted = status == PermissionStatus.granted;
    setState(() {
      _isPermissionGranted = isGranted;
    });
    if (widget.onPermissionChanged != null) {
      widget.onPermissionChanged!(isGranted);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isPermissionGranted
        ? widget.child
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Notification permission is required',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _requestNotificationPermission,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'Grant Permission',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
