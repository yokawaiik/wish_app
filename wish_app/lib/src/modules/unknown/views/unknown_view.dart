import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/state_manager.dart';
import 'package:wish_app/src/modules/unknown/controller/unknown_controller.dart';

class UnknownView extends GetView<UnknownController> {
  static const String routeName = "/not-found";
  const UnknownView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await controller.backHandler();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text("Page not found."),
        ),
      ),
    );
  }
}
