# av

An audio/video recording package for Flutter.

## iOS Usage

Add the NSMicrophoneUsageDescription key to your Info.plist:

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

Run the app:

```
flutter run -d ios
```
