# HyprMX - adapter info

***<font color='red'>This is recommended update</font>***

## Compatibililty

| Network | Adapter version | Third party SDK version | Fyber SDK version |
|:----------:|:-------------:|:-----------------------:|:------------:|
| HyprMX | 2.1.2 | 18 | 7.0.3 + |

**Important:** *The HyprMX Mobile SDK supports iOS 6 or higher. It will not return ads on iOS 5 and should not be initialized on iOS 4. To integrate HyprMX with an application supporting iOS 4, you will need to weak link the Foundation and CoreLocation libraries.*

## Migration guide from Fyber SDK 6.x to 7.x

After migration to Fyber SDK 7.x, the `name` parameter should be set to `HyprMx` instead of `HyprMX`. The minimum recommended adapter version for Fyber SDK 7.x is **2.1.2**.

## Example parameters

* **name**: `HyprMx`
* **settings**:
	* **SPHyprMXDistributorID**
	* **SPHyprMXPropertyID**


## Required frameworks

* `Accelerate.framework`
* `AdSupport.framework`
* `AVFoundation.framework`
* `CoreGraphics.framework`
* `CoreLocation.framework`
* `CoreMedia.framework`
* `Foundation.framework`
* `MessageUI.framework`
* `MobileCoreServices.framework`
* `QuartzCore.framework`
* `SystemConfiguration.framework`
* `UIKit.framework`

## Required linker flags

* `-ObjC`
* `-all_load`