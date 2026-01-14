import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoInternetScreen extends StatefulWidget {
  final Widget child;
  final VoidCallback? onConnected; // Callback for when internet is connected

  const NoInternetScreen({
    Key? key,
    required this.child,
    this.onConnected,
  }) : super(key: key);

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isConnected = true;
  bool _wasDisconnected = false; // Track if we were previously disconnected

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkInitialConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    setState(() {
      bool newConnectionStatus =
          results.any((result) => result != ConnectivityResult.none);

      // If we were disconnected and now we're connected, call the callback
      if (_wasDisconnected &&
          newConnectionStatus &&
          widget.onConnected != null) {
        widget.onConnected!();
      }

      // Update the connection status
      _isConnected = newConnectionStatus;

      // If we're not connected, mark that we were disconnected
      if (!_isConnected) {
        _wasDisconnected = true;
      }
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isConnected) {
      return widget.child;
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.string(
                  NoInternetSVG.svgCode,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 32),
                Text(
                  'No Internet Connection',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.error,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Please check your internet connection and try again',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _checkInitialConnectivity,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// SVG code for the no internet image
class NoInternetSVG {
  static const String svgCode = '''
<svg fill="none" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg"><g stroke="#d0d1d6" stroke-width="1.5"><path d="m5 5c-1.85136 1.79995-3 4.3082-3 7.0825 0 5.4773 4.47715 9.9175 10 9.9175 2.7255 0 5.1962-1.0813 7-2.835"/><path d="m15.5 16c-.6172 3.5318-1.8597 6-3.5 6-2.20914 0-4-4.4772-4-10 0-1.2313.08902-2.41066.25184-3.5" stroke-linecap="round"/><path d="m2 12h10" stroke-linecap="round" stroke-linejoin="round"/></g><path d="m7.16204 2.39775c-.36977.18665-.51823.63772-.33158 1.0075s.63772.51823 1.0075.33158zm13.10066 13.76415c-.1867.3698-.0383.8209.3314 1.0076.3698.1867.8209.0383 1.0076-.3314zm-4.2627-4.1619h-.75c0 .4142.3358.75.75.75zm-7.69739-7.2738c-.15121.38563.03882.82082.42444.97204.38563.15121.82082-.03882.97204-.42444zm3.69739-1.9762c5.1086 0 9.25 4.14137 9.25 9.25h1.5c0-5.93706-4.8129-10.75-10.75-10.75zm-4.16204.98683c1.25018-.63104 2.66344-.98683 4.16204-.98683v-1.5c-1.7387 0-3.38295.41333-4.83796 1.14775zm13.41204 8.26317c0 1.4986-.356 2.9118-.9873 4.1619l1.339.6762c.7346-1.455 1.1483-3.0992 1.1483-4.8381zm-9.25-9.25c.2796 0 .6219.13858 1.0121.55118.3917.41418.779 1.05377 1.12 1.9063.6803 1.70089 1.1179 4.10209 1.1179 6.79252h1.5c0-2.83241-.4579-5.43122-1.2252-7.34961-.3829-.95712-.8575-1.782-1.4229-2.37987-.5669-.59946-1.2769-1.02052-2.1019-1.02052zm-2.30091 2.5238c.33541-.85525.75541-1.50931 1.18401-1.93743.433-.43249.8218-.58637 1.1169-.58637v-1.5c-.8238 0-1.5716.42044-2.17697 1.02511-.60974.60904-1.12981 1.45498-1.52042 2.45109zm6.30091 7.4762h6v-1.5h-6z" fill="#d0d1d6"/><path d="m2 2 20.0004 20.0004" stroke="#d0d1d6" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"/></svg>
''';
}
