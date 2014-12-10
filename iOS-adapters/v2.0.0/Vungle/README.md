# Vungle - adapter info

## Compatibililty

| Network | Adapter version | Third party SDK version | Fyber SDK version |
|:----------:|:-------------:|:-----------------------:|:------------:|
| Vungle | 2.2.0 | 3.0.10 | 7.0.2 |

## Example parameters

* **name**: `Vungle`
* **settings**:
	* **SPVungleAppId**
* **SPVungleShowClose**: `NO` | `YES`
* **SPVungleOrientation**: `all` | `portrait` | `landscapeLeft` | `landscapeRight` | `portraitUpsideDown` | `landscape` | `allButUpsideDown`


## Required frameworks

* `AdSupport.framework` (Mark as Optional to support < iOS 6.0)
* `AudioToolbox.framework`
* `AVFoundation.framework`
* `CFNetwork.framework`
* `CoreGraphics.framework`
* `CoreMedia.framework`
* `Foundation.framework`
* `libz.dylib`
* `libsqlite3.dylib`
* `MediaPlayer.framework`
* `QuartzCore.framework`
* `StoreKit.framework` (Mark as Optional to support < iOS 6.0)
* `SystemConfiguration.framework`
* `UIKit.framework`

## Required linker flags

 none