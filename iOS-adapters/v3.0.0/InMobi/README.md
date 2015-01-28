# InMobi  - adapter info

## Compatibililty

| Network | Adapter version | Third party SDK version | Fyber SDK version |
|:----------:|:-------------:|:-----------------------:|:------------:|
| InMobi | 3.0.0 | 4.5.1 | 7.0.3 |

## Example parameters

* **name**: `InMobi `
* **settings**:

	* **SPInMobiAppId**
	* **SPInMobiRewardedVideoPropertyId**
	* **SPInMobiLogLevel**  `none` | `debug` | `verbose`


## Required frameworks

* `AdSupport.framework` (Mark as Optional to support < iOS 6.0)
* `AudioToolbox.framework`
* `AVFoundation.framework`
* `CoreLocation.framework`
* `CoreTelephony.framework`
* `EventKit.framework`
* `EventKitUI.framework`
* `MediaPlayer.framework`
* `MessageUI.framework`
* `Security.framework`
* `Social.framework` (Mark as Optional to support < iOS 6.0)
* `StoreKit.framework` (Mark as Optional to support < iOS 6.0)
* `SystemConfiguration.framework`
* `libsqlite3.0.dylib`
* `libz.dylib`

## Required linker flags

* `-ObjC`
