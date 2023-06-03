# av

An audio/video recording and streaming package for Flutter.

## iOS Usage

If your app needs access to the device's microphone, add the NSMicrophoneUsageDescription key to ios/Runner/Info.plist:

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

If your app needs access to the device's camera, add the NSCameraUsageDescription key to ios/Runner/Info.plist:

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


Run the app:

```
flutter run -d ios
```
