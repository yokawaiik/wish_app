import 'package:flutter/material.dart';

import '../../navigator/utils/show_exit_app.dart';

class RequireConnectionWidget extends StatelessWidget {
  final bool hasConnection;
  final Widget primaryWidget;

  const RequireConnectionWidget(
      {required this.hasConnection, required this.primaryWidget, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hasConnection) {
      return primaryWidget;
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: const [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: showExitPopup,
            ),
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.signal_cellular_nodata,
                color: Theme.of(context).colorScheme.primary,
                size: 100,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text('Please, check your internet connection...')
            ],
          ),
        ),
      );
    }
  }
}
