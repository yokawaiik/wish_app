import 'package:get/get.dart';
import 'package:wish_app/src/modules/home/services/home_service.dart';
import 'package:wish_app/src/modules/splash/views/splash_view.dart';

class HomeController extends GetxController {


  Future<void> signOut() async {
    printInfo(info: 'HomeController - signOut()');
    await HomeService.signOut();
    await Get.offAllNamed(SplashView.routeName);
  }
}
