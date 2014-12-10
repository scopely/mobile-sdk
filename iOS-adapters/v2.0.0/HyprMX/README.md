# HyprMX - adapter info

## Compatibililty

| Network | Adapter version | Third party SDK version | Fyber SDK version |
|:----------:|:-------------:|:-----------------------:|:------------:|
| HyprMX | 2.1.1 | 18 | 7.0.0 |

**Important:** *The HyprMX Mobile SDK supports iOS 6 or higher. It will not return ads on iOS 5 and should not be initialized on iOS 4. To integrate HyprMX with an application supporting iOS 4, you will need to weak link the Foundation and CoreLocation libraries.*

## Example parameters

* **name**: `HyprMX`
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