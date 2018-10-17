//
//  iToast.m
//  iToast
//
//  Created by Diallo Mamadou Bobo on 2/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "iToast.h"
#import <QuartzCore/QuartzCore.h>

static iToastSettings *sharedSettings = nil;

@interface iToast(private)

- (iToast *) settings;

@end


@implementation iToast

- (void)dealloc
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (id) initWithText:(NSString *) tex
{
	if (self = [super init]) 
    {
		text = [tex copy];
	}
	return self;
}

- (id) initWithAttributeText:(NSMutableAttributedString *) attributext
{
    if (self = [super init])
    {
        attributeText = [attributext copy];
    }
    return self;
}

- (void) show
{
	iToastSettings *theSettings = _settings;
	if (!theSettings) 
    {
		theSettings = [iToastSettings getSharedSettings];
	}
	
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    UIFont *font = [UIFont systemFontOfSize:14];
    //CGSize textSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(280, 40)];
    //  最长限制12个字
    //NSString *maxLmtStr = @"浮层提示文字最多12个字。";
    //CGSize maxLmtTextSize = [maxLmtStr strSizeWithFont:14 maxSize:MAX_SIZE];
    
    //CGSize textSize = [text strSizeWithFont:14 maxSize:MAX_SIZE];
    //CGFloat textSizeWidth = textSize.width;
    //if (textSize.width >= maxLmtTextSize.width) {
    //    textSizeWidth = maxLmtTextSize.width;
    //}
    CGFloat textSizeWidth = [text boundingRectWithSize:CGSizeMake(280, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width;
    CGFloat textSizeHeight = [text boundingRectWithSize:CGSizeMake(280, 60) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
    UIButton *infoBtn = (UIButton *)[window viewWithTag:998];
    if (infoBtn && isShared) {
        UILabel *infoLb = (UILabel *)[window viewWithTag:1024];
        if (infoLb) {
           
            infoLb.text = text;
            infoLb.frame = CGRectMake(0, 0, textSizeWidth , textSizeHeight );
        }
    } else {
       
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSizeWidth , textSizeHeight )];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = font;
        label.text = text;
        label.numberOfLines = 0;
        label.shadowColor = [UIColor darkGrayColor];
        label.shadowOffset = CGSizeMake(1, 1);
        label.tag = 1024;
        
        UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];
        v.frame = CGRectMake(0, 0, textSizeWidth + 20, textSizeHeight + 20);
        label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
        [v addSubview:label];
        [v setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    //    v.layer.cornerRadius = 18;
        if (self.cornerRadius) {
            v.layer.cornerRadius = self.cornerRadius;
        } else {
            v.layer.cornerRadius = 18;
        }
        v.tag = 998;
        
        CGPoint point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
        
        if (theSettings.gravity == iToastGravityTop) {
            point = CGPointMake(window.frame.size.width / 2,  window.frame.size.height - 45);
        }else if (theSettings.gravity == iToastGravityBottom) {
//            point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 45);
            point = CGPointMake(window.frame.size.width /4,  window.frame.size.height - 45);

        }else if (theSettings.gravity == iToastGravityCenter) {
//            point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
            point = CGPointMake(window.frame.size.width * 3 / 4,  window.frame.size.height - 45);

        }else{
            point = theSettings.postition;
        }
        
        point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
        v.center = point;
        
        [window addSubview:v];
        
        view = v;
        
        [v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];
    }
	
    if (isShared) {
        if (timer) {
            [self invalidateShowedTimer];
        }
        timer = [NSTimer timerWithTimeInterval:((float)theSettings.duration)/1000
                                        target:self selector:@selector(hideToast:)
                                      userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    } else {
        NSTimer *timer1 = [NSTimer timerWithTimeInterval:((float)theSettings.duration)/1000
                                                  target:self selector:@selector(hideToast:)
                                                userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    }
}

- (void) attributeShow
{
    iToastSettings *theSettings = _settings;
    if (!theSettings)
    {
        theSettings = [iToastSettings getSharedSettings];
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    UIButton *infoBtn = (UIButton *)[window viewWithTag:998];
    if (infoBtn && isShared) {
        UILabel *infoLb = (UILabel *)[window viewWithTag:1024];
        if (infoLb) {
            infoLb.text = text;
        }
    } else {
        //  最长限制12个字
        NSString *maxLmtStr = @"浮层提示文字最多12个字。";
        CGSize maxLmtTextSize = [maxLmtStr strSizeWithFont:14 maxSize:MAX_SIZE];
        
        CGSize textSize = [text strSizeWithFont:14 maxSize:MAX_SIZE];
        if (textSize.width == 0 && attributeText) {
            textSize = [attributeText boundingRectWithSize:MAX_SIZE options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        }
        CGFloat textSizeWidth = textSize.width;
        if (textSize.width >= maxLmtTextSize.width) {
            textSizeWidth = textSize.width;
        }
        //CGFloat textSizeWidth = [attributeText boundingRectWithSize:CGSizeMake(280, 60) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
        CGFloat textSizeHeight = [attributeText boundingRectWithSize:CGSizeMake(280, 60) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSizeWidth , textSizeHeight )];
        label.backgroundColor = [UIColor clearColor];
        label.attributedText = attributeText;
        label.numberOfLines = 0;
        label.shadowColor = [UIColor darkGrayColor];
        label.shadowOffset = CGSizeMake(1, 1);
        
        UIButton *v = [UIButton buttonWithType:UIButtonTypeCustom];
        v.frame = CGRectMake(0, 0, textSizeWidth + 20, textSizeHeight + 20);
        label.center = CGPointMake(v.frame.size.width / 2, v.frame.size.height / 2);
        [v addSubview:label];
        [v setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
    //    v.layer.cornerRadius = 18;
        if (self.cornerRadius) {
            v.layer.cornerRadius = self.cornerRadius;
        } else {
            v.layer.cornerRadius = 18;
        }
        
        CGPoint point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
        
        if (theSettings.gravity == iToastGravityTop) {
            point = CGPointMake(window.frame.size.width / 2, 45);
        }else if (theSettings.gravity == iToastGravityBottom) {
            point = CGPointMake(window.frame.size.width / 2, window.frame.size.height - 45);
        }else if (theSettings.gravity == iToastGravityCenter) {
            point = CGPointMake(window.frame.size.width/2, window.frame.size.height/2);
        }else{
            point = theSettings.postition;
        }
        
        point = CGPointMake(point.x + offsetLeft, point.y + offsetTop);
        v.center = point;
        
        [window addSubview:v];
        
        view = v;
        
        [v addTarget:self action:@selector(hideToast:) forControlEvents:UIControlEventTouchDown];
    }
    
    if (isShared) {
        if (timer) {
            [self invalidateShowedTimer];
        }
        timer = [NSTimer timerWithTimeInterval:((float)theSettings.duration)/1000
                                        target:self selector:@selector(hideToast:)
                                      userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    } else {
        NSTimer *timer1 = [NSTimer timerWithTimeInterval:((float)theSettings.duration)/1000
                                        target:self selector:@selector(hideToast:)
                                      userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    }
}

- (void)invalidateShowedTimer
{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void) hideToast:(NSTimer*)theTimer{

	[UIView beginAnimations:nil context:NULL];
	view.alpha = 0;
	[UIView commitAnimations];
    
	NSTimer *timer2 = [NSTimer timerWithTimeInterval:0
											 target:self selector:@selector(removeToast:)
										   userInfo:nil repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSDefaultRunLoopMode];
}

- (void) removeToast:(NSTimer*)theTimer{
	[view removeFromSuperview];
    view = nil;
}

#pragma mark - 单例形式的Toast
static iToast *_toast = nil;
+ (iToast *)sharedToast
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _toast = [[iToast alloc] init];
    });
    _toast->isShared = YES;
    
    return _toast;
}

+ (iToast *) makeText:(NSString *) _text{
	iToast *toast = [[iToast alloc] initWithText:_text];
	
	return toast;
}
- (iToast *)makeText:(NSString *)_text {
  
   return  [self initWithText:_text];
}

+ (iToast *) makeAttributeText:(NSMutableAttributedString *)_AttributeText{
    iToast *toast = [[iToast alloc] initWithAttributeText:_AttributeText];
    return toast;
}

- (iToast *) setDuration:(NSInteger ) duration{
	[self theSettings].duration = duration;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity 
			 offsetLeft:(NSInteger) left
			  offsetTop:(NSInteger) top{
	[self theSettings].gravity = gravity;
	offsetLeft = left;
	offsetTop = top;
	return self;
}

- (iToast *) setGravity:(iToastGravity) gravity{
	[self theSettings].gravity = gravity;
	return self;
}

- (iToast *) setPostion:(CGPoint) _position{
	[self theSettings].postition = CGPointMake(_position.x, _position.y);
	
	return self;
}

-(iToastSettings *) theSettings{
	if (!_settings) {
		_settings = [[iToastSettings getSharedSettings] copy];
	}
	
	return _settings;
}

@end


@implementation iToastSettings
@synthesize duration;
@synthesize gravity;
@synthesize postition;
@synthesize images;

- (void) setImage:(UIImage *) img forType:(iToastType) type{
	if (!images) {
		images = [[NSMutableDictionary alloc] initWithCapacity:4];
	}
	
	if (img) {
		NSString *key = [NSString stringWithFormat:@"%i", type];
		[images setValue:img forKey:key];
	}
}

+ (iToastSettings *) getSharedSettings{
	if (!sharedSettings) {
		sharedSettings = [iToastSettings new];
		sharedSettings.gravity = iToastGravityCenter;
		sharedSettings.duration = iToastDurationShort;
	}
	
	return sharedSettings;
}

- (id) copyWithZone:(NSZone *)zone{
	iToastSettings *copy = [iToastSettings new];
	copy.gravity = self.gravity;
	copy.duration = self.duration;
	copy.postition = self.postition;
	
	NSArray *keys = [self.images allKeys];
	
	for (NSString *key in keys){
		[copy setImage:[images valueForKey:key] forType:[key intValue]];
	}
	
	return copy;
}

@end
