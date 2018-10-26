//
//  SKPSMTPMessage.h
//
//  Created by Ian Baird on 10/28/08.
//
//  Copyright (c) 2008 Skorpiostech, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <CFNetwork/CFNetwork.h>

enum 
{
    kSKPSMTPIdle = 0,
    kSKPSMTPConnecting,
    kSKPSMTPWaitingEHLOReply,
    kSKPSMTPWaitingTLSReply,
    kSKPSMTPWaitingLOGINUsernameReply,
    kSKPSMTPWaitingLOGINPasswordReply,
    kSKPSMTPWaitingAuthSuccess,
    kSKPSMTPWaitingFromReply,
    kSKPSMTPWaitingToReply,
    kSKPSMTPWaitingForEnterMail,
    kSKPSMTPWaitingSendSuccess,
    kSKPSMTPWaitingQuitReply,
    kSKPSMTPMessageSent
};
typedef NSUInteger SKPSMTPState;
    
// Message part keys
extern NSString *kSKPSMTPPartContentDispositionKey;
extern NSString *kSKPSMTPPartContentTypeKey;
extern NSString *kSKPSMTPPartMessageKey;
extern NSString *kSKPSMTPPartContentTransferEncodingKey;

// Error message codes
#define kSKPSMPTErrorConnectionTimeout -5
#define kSKPSMTPErrorConnectionFailed -3
#define kSKPSMTPErrorConnectionInterrupted -4
#define kSKPSMTPErrorUnsupportedLogin -2
#define kSKPSMTPErrorTLSFail -1
#define kSKPSMTPErrorNonExistentDomain 1
#define kSKPSMTPErrorInvalidUserPass 535
#define kSKPSMTPErrorInvalidMessage 550
#define kSKPSMTPErrorNoRelay 530

@class SKPSMTPMessage;

@protocol SKPSMTPMessageDelegate
@required

-(void)messageSent:(SKPSMTPMessage *)message;
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error;

@end

@interface SKPSMTPMessage : NSObject <NSCopying, NSStreamDelegate>
{
    NSString *_login;
    NSString *_pass;
    NSString *_relayHost;
    NSArray *_relayPorts;
    
    NSString *_subject;
    NSString *_fromEmail;
    NSString *_toEmail;
	NSString *_ccEmail;
	NSString *_bccEmail;
    NSArray *_parts;
    
    NSOutputStream *_outputStream;
    NSInputStream *_inputStream;
    
    BOOL _requiresAuth;
    BOOL _wantsSecure;
    BOOL _validateSSLChain;
    
    SKPSMTPState _sendState;
    BOOL _isSecure;
    NSMutableString *_inputString;
    
    // Auth support flags
    BOOL _serverAuthCRAMMD5;
    BOOL _serverAuthPLAIN;
    BOOL _serverAuthLOGIN;
    BOOL _serverAuthDIGESTMD5;
    
    // Content support flags
    BOOL _server8bitMessages;
    
   __weak id <SKPSMTPMessageDelegate> _delegate;
    
    NSTimeInterval _connectTimeout;
    
    NSTimer *_connectTimer;
    NSTimer *_watchdogTimer;
}

@property (nonatomic, assign) SKPSMTPState sendState;

@property(nonatomic, strong) NSString *login;
@property(nonatomic, strong) NSString *pass;
@property(nonatomic, strong) NSString *relayHost;

@property(nonatomic, strong) NSArray *relayPorts;
@property(nonatomic, assign) BOOL requiresAuth;
@property(nonatomic, assign) BOOL wantsSecure;
@property(nonatomic, assign) BOOL validateSSLChain;

@property(nonatomic, strong) NSString *subject;
@property(nonatomic, strong) NSString *fromEmail;
@property(nonatomic, strong) NSString *toEmail;
@property(nonatomic, strong) NSString *ccEmail;
@property(nonatomic, strong) NSString *bccEmail;
@property(nonatomic, strong) NSArray *parts;

@property(nonatomic, assign) NSTimeInterval connectTimeout;

@property(nonatomic, weak) id <SKPSMTPMessageDelegate> delegate;

- (BOOL)send;

@end
