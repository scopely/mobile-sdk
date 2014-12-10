# Unity Ads  - adapter info

## Compatibililty

| Network | Adapter version | Third party SDK version | Fyber SDK version |
|:----------:|:-------------:|:-----------------------:|:------------:|
| Unity Ads (formerly Applifier) | 2.2.0 | 1.3.8 | 6.5.2 |

## Example parameters

* **name**: `Unity Ads`
* **settings**:
	* **SPUnityAdsGameId**
	* **SPUnityAdsShowOffers**: `YES` | `NO`
	* **SPUnityAdsInterstitialZoneId**
	* **SPUnityAdsRewardedVideoZoneId**
	
## Required frameworks

* `AdSupport.framework` (Mark as Optional to support < iOS 6.0)
* `StoreKit.framework` (Mark as Optional to support < iOS 6.0)
         
## Required linker flags

none