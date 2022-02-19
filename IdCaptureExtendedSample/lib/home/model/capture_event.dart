/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

class CaptureEvent<T> {
  final T _content;

  CaptureEvent(this._content);

  T get content {
    return _content;
  }
}

class ResultEvent<CaptureResult> extends CaptureEvent {
  ResultEvent(content) : super(content);
}

class AskBackScan<Void> extends CaptureEvent {
  AskBackScan() : super(Void);
}
