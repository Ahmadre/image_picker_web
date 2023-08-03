## 3.1.1

* Fixed `MediaInfo.fromJson` parsing and added unit tests

## 3.1.0

* Updated Dart SDK constraint to `>=3.0.0 <4.0.0`
* Updated linting rules
* Changed license to MIT

## 3.0.0+1

* Fixed README.md

## 3.0.0

* **[BREAKING CHANGES]** Removed deprecated methods `getImage`, `getMultiImages` and `getVideo`
* Added methods `getMultiVideosAsBytes`, `getMultiVideosAsFile`

## 2.1.1

* Updated example project to null safety.
* Fixed potential issue with null value for methods `getImageInfo`, `getVideoAsBytes` and `getVideoInfo`.

## 2.1.0

* Deprecated `getImage`,  `getMultiImages` and `getVideo` methods.
* Added methods `getImageAsBytes`, `getImageAsWidget`, `getImageAsFile`, `getMultiImagesAsBytes`, `getMultiImagesAsWidget`, `getMultiImagesAsFile`,  `getVideoAsFile` and `getVideoAsBytes` ([#29](https://github.com/Ahmadre/image_picker_web/issues/29))

## 2.0.3+1

* Fixed a typo in the `README.md`

## 2.0.3

* Fixed issue [#25](https://github.com/Ahmadre/image_picker_web/issues/25) when clicking on cancel or close buttons
* Improved example file

## 2.0.2

* Fixed issue [#22](https://github.com/Ahmadre/image_picker_web/issues/22)

## 2.0.1

* Fixed `FutureOr<Map<String, dynamic>>` cast

## 2.0.0

* **Breaking Changes**: migrated code to nullsafety
* Removed deprecated properties

## 1.1.3

* Added `toJson` method to `MediaInfo`
* Fixed `getImageInfo` and `getVideoInfo`
* Updated `example/main.dart`

## 1.1.2+1

* Fixed `pickImage` and `pickVideo`

## 1.1.2

* Fixed compatibility with iOS web browser

## 1.1.1

* Upgraded minimum sdk to `>=2.7.0`
* Added new `ImageType.mediaInfo`
* Made some code refacto 

## 1.1.0+2

* Update README.md

## 1.1.0+1

* Format code to dartfm standard
* Added comments

## 1.1.0

* Retake of the discontinued package [image_picker_web](https://pub.dev/packages/image_picker_web)
* Refacto of method `getImage`
* Added method `getMultiImages` to allow multi-image selection
* Added a few comments for documentation generations
