import 'package:url_launcher/url_launcher.dart';

extension PriceLable on String {
  String get withPriceLable => '$this تومان';
}

class LaunchInBrowser {
 static Future<void> launchInBrowser(Uri url) async {
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
}
