#import <Foundation/Foundation.h>
#import <Accounts/AccountsDefines.h>

@class NSObject<OS_dispatch_semaphore>, APSConnection, NSData;

@interface AADeviceInfo : NSObject {

APSConnection *_apsConnection;

BOOL _tokenDone;

NSData *_token;

NSObject<OS_dispatch_semaphore> *_tokenSema;

}

+ (id)userAgentHeader;

+ (id)signatureWithDictionary:(id)arg1;

+ (id)apnsToken;

+ (id)serialNumber;

+ (id)clientInfoHeader;

+ (id)appleIDClientIdentifier;

+ (id)productVersion;

+ (id)osVersion;

+ (id)udid;

+ (id)infoDictionary;

- (id)wifiMacAddress;

- (id)regionCode;

- (id)deviceClass;

- (id)osName;

- (id)productType;

- (id)apnsToken;

- (id)serialNumber;

- (id)deviceInfoDictionary;

- (id)appleIDClientIdentifier;

- (id)productVersion;

- (id)osVersion;

- (id)udid;

- (id)init;

- (void).cxx_destruct;

- (id)buildVersion;

@end
