# av

An audio/video recording and streaming package for Flutter.

## Overview

Flutter AV is state management agnostic. By default, each widget is "smart" and wired directly to native audio/video state. You are given full control over each widget's appearance. You can also use the Flutter AV utility functions to wire up your own custom components directly to native audio/video state, or you can use the utility functions to sync native audio/video state with whatever state management library you choose. Flutter AV is extremely flexible.

## Installation

```sh
flutter pub add av
```

## iOS Setup

If your app needs to record audio, add the NSMicrophoneUsageDescription key to ios/Runner/Info.plist:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    ...
	<key>NSMicrophoneUsageDescription</key>
	<string>The app needs microphone access for capturing audio.</string>
    ...
</dict>
</plist>
```

If your app needs to record video, add the NSCameraUsageDescription key to ios/Runner/Info.plist:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    ...
	<key>NSCameraUsageDescription</key>
	<string>The app needs camera access for capturing video.</string>
    ...
</dict>
</plist>
```

## TODO: Android Setup

## TODO: Web Setup
