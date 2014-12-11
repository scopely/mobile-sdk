# AppLift - adapter info

***<font color='red'>This is recommended update</font>***

## Compatibililty

| Network | Adapter version | Third party SDK version | Fyber SDK version |
|:----------:|:-------------:|:-----------------------:|:------------:|
| AppLift  | 2.2.1 | 4.1.0 | 6.5.2 |

## Example parameters

* **name**: `AppLift`
* **settings**:
	* **SPAppLiftAppId**
	* **SPAppLiftSecretToken**
	
## Required frameworks
* `AdSupport.framework` (Mark as Optional to support < iOS 6.0)
* `CoreGraphics.framework`
* `CoreTelephony.framework`
* `Foundation.framework`
* `ImageIO.framework`
* `Security.framework`
* `StoreKit.framework` (Mark as Optional to support < iOS 6.0)
* `SystemConfiguration.framework`
* `UIKit.framework`

## Required linker flags

* `-ObjC`
