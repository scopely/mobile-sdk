# AdMob - adapter info

## Compatibililty

| Network | Adapter version | Third party SDK version | Fyber SDK version |
|:----------:|:-------------:|:-----------------------:|:------------:|
| AdMob | 2.0.2 | 6.12.2 | 7.0.2 |


## Example parameters

* **name**: `AdMob`
* **settings**:
	* **SPAdMobInterstitialAdUnitId**
	* **SPAdMobIsCOPPACompliant**: `YES` | `NO`
	* **SPAdMobTestDevices**: 
		*     `GAD_SIMULATOR_ID`
	
## Required frameworks

* `AdSupport.framework` (Mark as Optional to support < iOS 6.0)
* `AudioToolbox.framework`
* `AVFoundation.framework`
* `CoreGraphics.framework`
* `CoreTelephony.framework`
* `EventKit.framework`
* `EventKitUI.framework`
* `MessageUI.framework`
* `StoreKit.framework`  (Mark as Optional to support < iOS 6.0)
* `SystemConfiguration.framework`


## Required linker flags

* `-ObjC`