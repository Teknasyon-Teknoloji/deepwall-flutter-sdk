# Changelog
All notable changes to this project will be documented in this file.

## [Unreleased](https://github.com/Teknasyon-Teknoloji/deepwall-flutter-sdk/compare/3.0.1...main)


---


## [3.0.1 (2022-09-29)](https://github.com/Teknasyon-Teknoloji/deepwall-flutter-sdk/compare/3.0.0...3.0.1)
### Changed
- On Android, `deepwall-core` sdk version upgraded to version `2.6.6`.
- Update sdk dependencies (`pubspec.lock`).


## [3.0.0 (2022-05-06)](https://github.com/Teknasyon-Teknoloji/deepwall-flutter-sdk/compare/2.0.1...3.0.0)
### Fixed
- Fixed typo on readme file
- Added missing import to readme

### Changed
- On Android, `deepwall-core` version upgraded to version `2.6.2`
- On iOS, `deepwall-core` version upgraded to version `2.4.2`
- Example `main.dart` file updated

### Added
- On android added orientation parameter to `requestPaywall` method


## [2.0.1 (2022-01-27)](https://github.com/Teknasyon-Teknoloji/deepwall-flutter-sdk/compare/2.0.0...2.0.1)
### Fixed
- Removed todo's from android native code. (onDetachedFromActivity)


## [2.0.0 (2022-01-05)](https://github.com/Teknasyon-Teknoloji/deepwall-flutter-sdk/compare/1.4.1...2.0.0)
### Added
- Migrated to null safety

### Changed
- Readme updated.
- Due to null safety, minimum flutter version requirement is `2.12.0`.
- Example file updated.

## [1.4.1 (2022-01-04)](https://github.com/Teknasyon-Teknoloji/deepwall-flutter-sdk/compare/1.4.0...1.4.1)
### Changed
- Readme updated.
- On iOS, `deepwall-core` version updated to `2.4.1`.
- On Android, `deepwall-core` version updated to `2.4.1`

## [1.4.0 (2021-11-30)](https://github.com/Teknasyon-Teknoloji/deepwall-flutter-sdk/compare/1.3.0...1.4.0)
### Changed
- Readme updated.
- On iOS, `deepwall-core` version updated to `2.4.0`.
- On Android, `deepwall-core` version updated to `2.4.0`

## [1.3.0 (2021-04-09)](https://github.com/Teknasyon-Teknoloji/deepwall-flutter-sdk/compare/1.2.0...1.3.0)
### Added
- Added missing examples to [readme](README.md) file.

### Changed
- On iOS, `deepwall-core` version updated to `2.3.0`.
- On Android, `deepwall-core` version updated to `2.3.0`.
- On Android, kotlin version requirement is `1.4.32` or higher.

## [1.2.0 (2021-04-09)](https://github.com/Teknasyon-Teknoloji/deepwall-flutter-sdk/compare/1.1.0...1.2.0)
### Changed
- On iOS `deepwall-core` version upgraded to version `~> 2.2`.

### Added
- On iOS added new "requestAppTracking" method.
- On iOS added new "sendExtraDataToPaywall" method for sending extra data to paywalls.
- Added new event for ios "DeepWallEvents.ATT_STATUS_CHANGED".

## [1.1.0 (2021-04-01)](https://github.com/Teknasyon-Teknoloji/deepwall-flutter-sdk/compare/1.0.0...1.1.0)
## Fixed
- Added missing parameters for `setUserProperties` method
- debugAdvertiseAttributions parameter error fixed

## Changed
- On iOS deepwall-core version upgraded to version 2.1.0
- On Android deepwall-core version upgraded to version 2.2.2

## Added
- On iOS added `validateReceipt` implementation

## 1.0.0 (2021-02-11)
### Added
- Initial release.
