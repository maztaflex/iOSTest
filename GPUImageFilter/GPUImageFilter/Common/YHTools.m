//
//  YHTools.m
//
//  Created by DEV_TEAM1_IOS on 2015. 8. 25..
//  Copyright (c) 2015년 S.M Entertainment. All rights reserved.
//

#import "YHTools.h"
#import "AppDelegate.h"
#import <GAI.h>
#import <GAIDictionaryBuilder.h>
#import <GAIFields.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <UIImageView+WebCache.h>

@interface YHTools ()

@property (nonatomic, strong) NSCache *cachedImages;

@end

@implementation YHTools

static dispatch_once_t once;
static YHTools * __sharedInstance = nil;

+ (instancetype)sharedInstance
{
    if (!__sharedInstance)
    {
        dispatch_once(&once, ^{
            
            __sharedInstance = [[self alloc] init];
            
        });
    }
    
    return __sharedInstance;
}

- (id)init
{
    if (self = [super init]) {
        [self  initWithStoredImgsInCacheObj];
    }
    return self;
}

- (BOOL)isDevelopMode
{
    BOOL isDev = NO;
    
#if DEBUG || INHOUSE
    isDev = YES;
#endif
    
    return isDev;
}

- (id)getUserDefaultsValueWithKey:(NSString *)aKey
{
    id result = nil;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    result = [userDefaults objectForKey:aKey];
    
    return result;
}

- (void)setUserDefaultsWithObject:(id)obj key:(NSString *)aKey
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:obj forKey:aKey];
    
    [userDefaults synchronize];
}

#pragma mark - Hander for Images
- (void)initWithStoredImgsInCacheObj
{
    LogGreen(@"- (void)initWithStoredImgsInCacheObj");
    self.cachedImages = [[NSCache alloc] init];
    self.cachedImages.countLimit = 10;
}

// Get Image From Memory Cache
- (UIImage *)getImageFromMemoryCacheWithKey:(NSString *)key
{
    UIImage *result = nil;
    
    if (self.cachedImages == nil) {
        [self initWithStoredImgsInCacheObj];
    }
    
    result = [self.cachedImages objectForKey:key];
    
    return result;
}

// Save Image To Memory Cache
- (void)saveImageToMemoryCacheWithImage:(UIImage *)image Key:(NSString *)key
{
    if (self.cachedImages == nil) {
        [self initWithStoredImgsInCacheObj];
    }
    
    @try {
        [self.cachedImages setObject:image forKey:key];
    }
    @catch (NSException *exception) {
        LogRed(@"exception : %@",exception);
    }
}

// Get Image From Disk Cache
- (UIImage *)getImageFromLocalCacheWithFileName:(NSString *)fileName
{
    UIImage *result = nil;
    
    NSString *filePath = [[self getPathOfCacheDirectory] stringByAppendingPathComponent:fileName];
    
    result = [UIImage imageWithContentsOfFile:filePath];
    
    return result;
}

- (UIImage *)getImageFromFileNameWithCache:(NSString *)fileName
{
    return [self getImageFromFileNameWithCache:fileName andExt:@"png"];
}

- (UIImage *)getImageFromFileNameWithCache:(NSString *)fileName capInsets:(UIEdgeInsets)ei
{
    UIImage *result = [self getImageFromFileNameWithCache:fileName andExt:@"png"];
    
    result = [result resizableImageWithCapInsets:ei];
    
    return result;
}

- (UIImage *)getImageFromFileNameWithCache:(NSString *)fileName andExt:(NSString *)ext
{
    UIImage *result = nil;
    NSString *fileNameWithExt = [NSString stringWithFormat:@"%@.%@",fileName,ext];
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
    
    // 디스플레이에 맞는 이미지가 없을 경우 Retina로 대체 ( Pad 이미지는 별도로 Standard 이미지 필요함 )
    if (resourcePath == nil || [resourcePath isEqualToString:@""]) {
        fileName = [fileName stringByAppendingString:@"@2x"];
        fileNameWithExt = [NSString stringWithFormat:@"%@.%@",fileName,ext];
        resourcePath = [[NSBundle mainBundle] pathForResource:fileName ofType:ext];
    }
    
    // 캐싱되어 있으면 캐시 데이터로 부터 리턴
    result = [self.cachedImages objectForKey:fileNameWithExt];
    if (result != nil) {
        return result;
    }
    
    result = [UIImage imageWithContentsOfFile:resourcePath];
    
    [self.cachedImages setObject:result forKey:fileNameWithExt];
    
    return result;
}

- (UIImage *)getSplashImageWithFileName:(NSString *)fileName
{
    UIImage *result = nil;
    
    CGFloat screenHeight = [self screenHeightWithConsideredOrientation];
    
    if (screenHeight == 480.0f) {
        fileName = [fileName stringByAppendingString:@"-480h@2x"];
    }
    
    if (screenHeight == 568.0f) {
        fileName = [fileName stringByAppendingString:@"-568h@2x"];
    }
    
    if (screenHeight == 667.0f) {
        fileName = [fileName stringByAppendingString:@"-667h@2x"];
    }
    
    if (screenHeight == 736.0f) {
        fileName = [fileName stringByAppendingString:@"-736h@3x"];
    }
    
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"png"];
    result = [UIImage imageWithContentsOfFile:resourcePath];
    
    return result;
}


- (void)saveImageFileToCacheDirectoryFromURL:(NSString *)urlStr
{
    NSString *fileName = [urlStr lastPathComponent];
    NSString *savePath = [[self getPathOfCacheDirectory] stringByAppendingPathComponent:fileName];
    
    dispatch_async(dispatch_queue_create("com.smtown.imagedownload",NULL), ^{
        
        NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
        
        [imgData writeToFile:savePath atomically:YES];
    });
}

- (BOOL)saveImageDataToLocalCacheDirectoryWithImageObj:(UIImage *)img fileName:(NSString *)fileName
{
    BOOL isSuccess = NO;
    
//    NSData *imgData = UIImageJPEGRepresentation(img, 1.0f);
    NSData *imgData = UIImagePNGRepresentation(img);
    
    NSString *saveFilePath = [[self getPathOfCacheDirectory] stringByAppendingPathComponent:fileName];

    isSuccess = [imgData writeToFile:saveFilePath atomically:YES];
    
    return isSuccess;
}

- (void)setImageToImageView:(UIImageView *)targetImageView
           placeholderImage:(UIImage *)placeholderImage
             imageURLString:(NSString *)imageUrl
            isOnlyMemoryCache:(BOOL)onlyMemoryCache
{
    NSURL *imgURL = [NSURL URLWithString:imageUrl];
    
    SDWebImageCompletionBlock completionBlock = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        if (image && (cacheType == SDImageCacheTypeNone))
        {
            [targetImageView.layer addAnimation:[self fadeOutAnimationForChangeImage] forKey:@"fadeOutAnimationForChangeImage"];
        }
    };
    
    if (onlyMemoryCache == YES) {
        [targetImageView sd_setImageWithURL:imgURL
                           placeholderImage:placeholderImage
                                    options:SDWebImageCacheMemoryOnly
                                  completed:completionBlock];
    }
    else
    {
        [targetImageView sd_setImageWithURL:imgURL
                           placeholderImage:placeholderImage completed:completionBlock];
    }
}
    
- (void)setImageToImageView:(UIImageView *)targetImageView
           placeholderImage:(UIImage *)placeholderImage
             imageURLString:(NSString *)imageUrl
          isOnlyMemoryCache:(BOOL)onlyMemoryCache completion:(void(^)(void))completion
{
    NSURL *imgURL = [NSURL URLWithString:imageUrl];
    
    SDWebImageCompletionBlock completionBlock = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
        
        if (image && (cacheType == SDImageCacheTypeNone))
        {
            [targetImageView.layer addAnimation:[self fadeOutAnimationForChangeImage] forKey:@"fadeOutAnimationForChangeImage"];
        }
        
        if (completion) {
            completion();
        }
    };
    
    if (onlyMemoryCache == YES) {
        [targetImageView sd_setImageWithURL:imgURL
                           placeholderImage:placeholderImage
                                    options:SDWebImageCacheMemoryOnly
                                  completed:completionBlock];
    }
    else
    {
        [targetImageView sd_setImageWithURL:imgURL
                           placeholderImage:placeholderImage completed:completionBlock];
    }
}

- (void)setImageToImageView:(UIImageView *)targetImageView
           placeholderImage:(UIImage *)placeholderImage
             imageURLString:(NSString *)imageUrl
            usingLocalCache:(BOOL)useLocalCache
         useChangeAnimation:(BOOL)changeAnimation
                 completion:(void(^)(void))completion
{
    NSString *imageFileName = [imageUrl lastPathComponent];
    UIImage *memCachedImage = [self getImageFromMemoryCacheWithKey:imageFileName];
    UIImage *localCachedImage = nil;
    
    if (memCachedImage != nil)
    {
        targetImageView.image = memCachedImage;
        if (changeAnimation == YES) [targetImageView.layer addAnimation:[self fadeOutAnimationForChangeImage] forKey:nil];
        
        if (completion) {
            completion();
        }
        
        return;
    }
    
    localCachedImage = [self getImageFromLocalCacheWithFileName:imageFileName];
    
    if (localCachedImage == nil)
    {
        // Start download file, If doesn't exist image file in local cache directory.
        __block UIImageView *weakImageView = targetImageView;
        [targetImageView setImageWithURLRequest:[self makeRequestForLoadWebViewWithURLString:imageUrl] placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            // Save downloaded image data in local cache directory, if useCachedImage = YES
            if (useLocalCache == YES) {
                
                dispatch_async(dispatch_queue_create("com.smtown.saveimage",NULL),^{
                    [self saveImageDataToLocalCacheDirectoryWithImageObj:image fileName:[imageUrl lastPathComponent]];
                });
            }
            
            // UI Update
            dispatch_async(dispatch_get_main_queue(), ^{
                weakImageView.image = image;
                if (changeAnimation == YES) {
                    [weakImageView.layer addAnimation:[self fadeOutAnimationForChangeImage] forKey:nil];
                }
                if (completion) {
                    completion();
                }
            });
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            LogRed(@"error : %@",error);
        }];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            targetImageView.image = localCachedImage;
            if (changeAnimation == YES) [targetImageView.layer addAnimation:[self fadeOutAnimationForChangeImage] forKey:nil];
            [self.cachedImages setObject:localCachedImage forKey:imageFileName];
            if (completion) {
                completion();
            }
        });
    }
}

- (UIImage * )imageResizeWithImage:(UIImage *)image size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage*scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

// Get Ratio Height
- (CGFloat)getRatioHeightByWidth:(CGFloat)width originImageSize:(CGSize)imgSize
{
    CGFloat result = CGFLOAT_MIN;
    
    result = width * (imgSize.height / imgSize.width);
    
    if (isnan(result)) {
        result = width;
    }
    
    return result;
}
- (CGFloat)getRatioHeightByWidth:(CGFloat)width originImage:(UIImage *)image
{
    CGFloat result = CGFLOAT_MIN;
    
    CGSize imageSize = image.size;
    
    result = width * (imageSize.height / imageSize.width);
    
    if (isnan(result)) {
        result = width;
    }
    
    return result;
}

- (UIColor *)getColorByStringHexCode:(NSString *)strHexCode
{
    UIColor *result = nil;
    NSScanner *scanner = nil;
    unsigned redCode, greenCode, blueCode;
    NSRange r;
    
    r.location = 0;
    r.length = 2;
    NSString *redCodeStr = [strHexCode substringWithRange:r];
    
    r.location = 2;
    NSString *greenCodeStr = [strHexCode substringWithRange:r];
    
    r.location = 4;
    NSString *blueCodeStr = [strHexCode substringWithRange:r];
    
    scanner = [NSScanner scannerWithString:redCodeStr];
    [scanner scanHexInt:&redCode];
    
    scanner = [NSScanner scannerWithString:greenCodeStr];
    [scanner scanHexInt:&greenCode];
    
    scanner = [NSScanner scannerWithString:blueCodeStr];
    [scanner scanHexInt:&blueCode];
    
    result = [UIColor colorWithRed:redCode/255.0f green:greenCode/255.0f blue:blueCode/255.0f alpha:1];
    
    return result;
}

- (UIColor *)getColorByStringHexCode:(NSString *)strHexCode alpah:(CGFloat)alpha
{
    UIColor *result = nil;
    NSScanner *scanner = nil;
    unsigned redCode, greenCode, blueCode;
    NSRange r;
    
    r.location = 0;
    r.length = 2;
    NSString *redCodeStr = [strHexCode substringWithRange:r];
    
    r.location = 2;
    NSString *greenCodeStr = [strHexCode substringWithRange:r];
    
    r.location = 4;
    NSString *blueCodeStr = [strHexCode substringWithRange:r];
    
    scanner = [NSScanner scannerWithString:redCodeStr];
    [scanner scanHexInt:&redCode];
    
    scanner = [NSScanner scannerWithString:greenCodeStr];
    [scanner scanHexInt:&greenCode];
    
    scanner = [NSScanner scannerWithString:blueCodeStr];
    [scanner scanHexInt:&blueCode];
    
    result = [UIColor colorWithRed:redCode/255.0f green:greenCode/255.0f blue:blueCode/255.0f alpha:alpha];
    
    return result;
}

- (BOOL)isPad
{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

- (BOOL)isLandScapeOrientation
{
    UIDeviceOrientation orientationType = [UIDevice currentDevice].orientation;
    
    if (orientationType == UIDeviceOrientationLandscapeLeft || orientationType == UIDeviceOrientationLandscapeRight) {
        return YES;
    }
    
    return NO;
}

// Screen Width, Height 확인
- (CGFloat)screenWidthWithConsideredOrientation
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    CGFloat screenWidth = 0.0f;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        screenWidth = screenSize.width;
    }
    else
    {
        if ([self isLandScapeOrientation] == YES)
        {
            screenWidth = screenSize.height;
        }
        else
        {
            screenWidth = screenSize.width;
        }
    }
    
    return screenWidth;
}

- (CGFloat)screenHeightWithConsideredOrientation
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    CGFloat screenHeight = 0.0f;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        screenHeight = screenSize.height;
    }
    else
    {
        if ([self isLandScapeOrientation] == YES)
        {
            screenHeight = screenSize.width;
        }
        else
        {
            screenHeight = screenSize.height;
        }
    }
    
    return screenHeight;
}

- (NSString*)getAppVersion
{
    NSString *versionInfo = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    return versionInfo;
}

- (NSString*)getBuildVersion
{
    NSString *versionInfo = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    return versionInfo;
}

- (void)setLanguageCodeWithCode:(NSString *)lc
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:lc forKey:kSettingLanguageCode];
    
    [userDefaults synchronize];
}

- (NSString *)getLanguageCode
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *languageCode = [userDefaults objectForKey:kSettingLanguageCode];
    
    if (languageCode == nil || [languageCode isEqualToString:@""]) {
        languageCode = [[NSLocale preferredLanguages] objectAtIndex:0];
        
        languageCode = [[languageCode componentsSeparatedByString:@"-"] firstObject];
    }
    
    return languageCode;
}

- (NSString *)getCountryCode
{
    return [NSLocale currentLocale].localeIdentifier;
}

- (void)setCurrencyCode:(NSString *)currencyCode
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:currencyCode forKey:kSettingCurrencyCode];
    
    [userDefaults synchronize];
}

- (NSString *)getCurrencyCode
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSString *currencyCode = [userDefaults objectForKey:kSettingCurrencyCode];
    
    if (currencyCode == nil || [currencyCode isEqualToString:@""])
    {
        currencyCode =[[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
    }
    
    return currencyCode;
}

- (NSString *)getCurrencySymbol
{
    return [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
}

- (NSString *)getLocalizedStringWithKey:(NSString *)key
{
    NSString *result = nil;
    
    NSString *currentLanguageCode = [self getLanguageCode];
    
    if([currentLanguageCode isEqualToString:@"ch"])
    {
        currentLanguageCode = @"zh";
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LocalizedString" ofType:@"strings" inDirectory:nil forLocalization:currentLanguageCode];
    
    if (path == nil) {
        path = [[NSBundle mainBundle] pathForResource:@"LocalizedString" ofType:@"strings" inDirectory:nil forLocalization:currentLanguageCode];
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    result = [dict objectForKey:key];
    
    if (result == nil) {
        result = @"Not Localized";
    }
    
    return result;
}

- (NSString *)getPathOfCacheDirectory
{
    NSString *result = nil;
    
    result = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    return result;
}

- (NSURLRequest *)makeRequestForLoadWebViewWithURLString:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
    
    return req;
}

- (CGFloat)getStringHeightWithString:(NSString *)str maxWidth:(CGFloat)maxWidth font:(UIFont *)fontType
{
    CGFloat result = 0.0f;
    
    NSDictionary *attr = @{NSFontAttributeName : fontType};
    
    CGRect textRect = [str boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    
    result = textRect.size.height;
    
    return result;
}

- (CGFloat)getStringHeightWithString:(NSString *)str maxWidth:(CGFloat)maxWidth maxLine:(NSInteger)maxLine font:(UIFont *)fontType
{
    CGFloat result = 0.0f;
    
    NSDictionary *attr = @{NSFontAttributeName : fontType};
    
    NSString *checkChar = @"K";
    CGSize checkCharSize = [checkChar sizeWithAttributes:attr];
    
    CGRect textRect = [str boundingRectWithSize:CGSizeMake(maxWidth, maxLine * checkCharSize.height) options: NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    
    result = textRect.size.height;
    
    return result;
}


- (CGFloat)getStringHeightWithString:(NSString *)str maxWidth:(CGFloat)maxWidth font:(UIFont *)fontType lineSpacing:(NSInteger)spacing
{
    CGFloat result = 0.0f;
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    [paragrahStyle setLineSpacing:spacing];
    
    NSDictionary *attr = @{NSFontAttributeName : fontType,
                           NSParagraphStyleAttributeName : paragrahStyle};
    
    CGRect textRect = [str boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    
    result = textRect.size.height;
    
    return result;
}

- (CGFloat)getHeightOfAttributedString:(NSString *)str maxWidth:(CGFloat)maxWidth attr:(NSDictionary *)attr
{
    CGFloat result = 0.0f;
    
    CGRect textRect = [str boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options: NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
    
    result = textRect.size.height;
    
    return result;
}

- (double)randomFromMinimum: (double) min toMax:(double) max
{
    double result = 0.0f;
    
    double random = arc4random() / ((double) (((long long)2<<31) -1));
    
    result = random / (max-min) + min;
    
    return result;
}

- (NSURLRequest *)getRequestObjWithURLString:(NSString *)urlStr
{
    return [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr]];
}

- (NSURLRequest *)getRequestObjWithURLString:(NSString *)urlStr cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval
{
    return [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlStr] cachePolicy:cachePolicy timeoutInterval:timeoutInterval];
}

- (void)addModalAnimationWithView:(UIView *)view isPresent:(BOOL)isPresent
{
    CATransition* transition = [CATransition animation];
    transition.duration = 0.28f;
    
    if (isPresent == YES)
    {
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
    }
    else
    {
        transition.type = kCATransitionReveal;
        transition.subtype = kCATransitionFromBottom;
    }
    
    [view.layer addAnimation:transition forKey:kCATransition];
}

- (CATransition *)fadeOutAnimationForChangeImage
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    return transition;
}

- (void)drawSquareLineWithTargetView:(UIView *)targetView
                               Color:(UIColor *)lineColor
                           lineWidth:(CGFloat)lineWidth
                            drawType:(YHDrawSquareType)drawType

{
    CGRect bounds = targetView.bounds;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    
    switch (drawType)
    {
        case YHDrawSquareTypeAllLine:
            CGContextMoveToPoint(context, 0.0f, 0.0f);
            CGContextAddLineToPoint(context, bounds.size.width, 0.0f);
            CGContextAddLineToPoint(context, bounds.size.width, bounds.size.height);
            CGContextAddLineToPoint(context, 0.0f, bounds.size.height);
            CGContextAddLineToPoint(context, 0.0f, 0.0f);
            break;
        case YHDrawSquareTypeExcludeTopLine:
            CGContextMoveToPoint(context, bounds.size.width, 0.0f);
            CGContextAddLineToPoint(context, bounds.size.width, bounds.size.height);
            CGContextAddLineToPoint(context, 0.0f, bounds.size.height);
            CGContextAddLineToPoint(context, 0.0f, 0.0f);
            break;
        case YHDrawSquareTypeExcludeLeftLine:
            CGContextMoveToPoint(context, 0.0f, 0.0f);
            CGContextAddLineToPoint(context, bounds.size.width, 0.0f);
            CGContextAddLineToPoint(context, bounds.size.width, bounds.size.height);
            CGContextAddLineToPoint(context, 0.0f, bounds.size.height);
            break;
        case YHDrawSquareTypeExcludeRightLine:
            CGContextMoveToPoint(context, bounds.size.width, 0.0f);
            CGContextAddLineToPoint(context, 0.0f, 0.0f);
            CGContextAddLineToPoint(context, 0.0f, bounds.size.height);
            CGContextAddLineToPoint(context, bounds.size.width, bounds.size.height);
            break;
        case YHDrawSquareTypeExcludeBottomLine:
            CGContextMoveToPoint(context, 0.0f, bounds.size.height);
            CGContextAddLineToPoint(context, 0.0f, 0.0f);
            CGContextAddLineToPoint(context, bounds.size.width, 0.0f);
            CGContextAddLineToPoint(context, bounds.size.width, bounds.size.height);
            break;
        default:
            
            break;
    }
    
    // and now draw the Path!
    CGContextStrokePath(context);
}


- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (id)getObjForKeyWithDictionary:(NSDictionary *)dic key:(NSString *)key
{
    id result;
    
    result = [dic objectForKey:key];
    
    if (result == [NSNull null]) {
        result = nil;
    }
    
    return result;
}

- (NSString *)getJsonStringWithDictionary:(NSDictionary *)dic prettyPrint:(BOOL)prettyPrint
{
    NSString *result = nil;
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic
                                                    options:(NSJSONWritingOptions) (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                      error:&error];
    if (!data)
    {
        LogRed(@"error: %@", error.localizedDescription);
        return @"[]";
    }
    else
    {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return result;
}

- (NSArray *)getAllCookies
{
    NSHTTPCookieStorage *cs = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    NSArray *cookies = cs.cookies;
    
    return cookies;
}

- (void)deleteAllCookies
{
    NSHTTPCookieStorage *cs = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [self getAllCookies];
    
    for (NSHTTPCookie *cookie in cookies) {
        [cs deleteCookie:cookie];
    }
}

#pragma mark - JSON String to Object
- (id)convertedObjectWithData:(id)data
{
    id convertedObject = nil;
    
    if ([data isKindOfClass:[NSString class]])
    {
        convertedObject = [NSJSONSerialization JSONObjectWithData:[(NSString *)data dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    }
    
    return convertedObject;
}

- (void)blockUI
{
    appDelegate.window.userInteractionEnabled = NO;
}

- (void)unblockUI
{
    appDelegate.window.userInteractionEnabled = YES;
}


- (NSMutableURLRequest *)getURLRequestWithURLString:(NSString *)url
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
}

- (NSMutableURLRequest *)getURLRequestWithHTTPMethod:(NSString *)methodType
                                                 url:(NSString *)url
                                     parameterString:(NSString *)paramStr
                                          encodeType:(NSString *)encodeType
{
    NSMutableURLRequest *request = [self getURLRequestWithURLString:url];
    
    if([methodType isEqualToString:@"POST"])
    {
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:methodType];
        
        if ([encodeType isEqualToString:@"euc-kr"])
        {
            // EUC-KR
            NSUInteger encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingEUC_KR);
            const char * encodedParamsStr = [paramStr cStringUsingEncoding:encoding];
            [request setHTTPBody:[NSData dataWithBytes:encodedParamsStr length:strlen(encodedParamsStr)]];
        }
        else // UTF-8
        {
            [request setHTTPBody:[NSData dataWithBytes:[paramStr UTF8String] length:strlen([paramStr UTF8String])]];
        }
    }
    
    return request;
}

- (NSString *)valueInQuery:(NSString *)query key:(NSString *)key
{
    NSString *result = nil;
    
    @try
    {
        NSArray *params = [query componentsSeparatedByString:@"&"];
        
        for (NSString *queryComponent in params) {
            
            if ([queryComponent hasPrefix:[NSString stringWithFormat:@"%@=",key]]) {
                NSArray *seperatedComponent = [queryComponent componentsSeparatedByString:@"="];
                result = [seperatedComponent objectAtIndex:1];
                result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
        }
    }
    @catch (NSException *exception) {
        LogRed(@"exception : %@",exception);
    }
    
    return result;
}


#pragma mark - Google Analytics
- (void)initGA
{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    [GAI sharedInstance].dispatchInterval = 10;
    
    [[GAI sharedInstance] trackerWithTrackingId:GA_TRACKER_ID];
}

- (void)sendGAWithCategory:(NSString *)category
                    action:(NSString *)action
                     label:(NSString *)label
                screenName:(NSString *)screenName
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:label
                                                           value:nil] build]];
    
}

- (void)sendScreenName:(NSString *)name
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}


@end
