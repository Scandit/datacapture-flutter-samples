import 'package:BarcodeCaptureViewsSample/bloc/bloc_base.dart';
import 'package:BarcodeCaptureViewsSample/home/model/home_section.dart';
import 'package:BarcodeCaptureViewsSample/route/barcode_capture_routes.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class HomeBloc extends Bloc {
  final _modes = [
    HomeSection('Split View', BCRoutes.SplitView),
  ];

  List<HomeSection> get modes => _modes;

  String get pluginVersion => DataCaptureVersion.pluginVersion;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
