# playground_flutter

1. `git clone git@github.com:sotayamashita/playground_flutter.git`
1. `cd playground_flutter`
1. `flutter analyze`
1. `flutter run`
## How to X

### Bulding for iOS

```bash
# with Intel Mac
$ flutter build ios --debug

Signing iOS app for device deployment using developer identity: "Apple Development: XXXXXX"
Running Xcode build...
 └─Compiling, linking and signing...                         6.4s
Xcode build done.                                           22.6s
Built /path/to/playground_flutter/build/ios/iphoneos.

# with Intel Mac
$ xcrun lipo -info /path/to/playground_flutter/build/ios/Debug-iphonesimulator/Runner.app/Runner
Non-fat file: /path/to/playground_flutter/build/ios/Debug-iphonesimulator/Runner.app/Runner is architecture: x86_64
```

### Localizaing

- https://flutter.dev/docs/development/accessibility-and-localization/internationalization#adding-your-own-localized-messages
- https://github.com/flutter/flutter/issues/68003
- https://github.com/flutter/website/tree/master/examples/internationalization/gen_l10n_example