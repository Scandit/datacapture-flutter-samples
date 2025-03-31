/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:BarcodeSelectionSettingsSample/bloc/bloc_base.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

class OpenSourceSoftwareLicenseInfoBloc extends Bloc {
  Future<OpenSourceSoftwareLicenseInfo> getOpenSourceSoftwareLicenseInfo() =>
      DataCaptureContext.getOpenSourceSoftwareLicenseInfo();
}
