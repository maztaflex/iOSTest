//
//  YHTools.h
//
//  Created by DEV_TEAM1_IOS on 2015. 8. 25..
//  Copyright (c) 2015년 S.M Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YHDrawSquareType) {
    YHDrawSquareTypeAllLine          = 0,
    YHDrawSquareTypeExcludeTopLine,
    YHDrawSquareTypeExcludeLeftLine,
    YHDrawSquareTypeExcludeRightLine,
    YHDrawSquareTypeExcludeBottomLine,
};

#define appDelegate ((AppDelegate *) [UIApplication sharedApplication].delegate)
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface YHTools : NSObject

@property (strong, nonatomic) NSString *urlForWebView;
@property (strong, nonatomic) NSString *paramUrl;

#pragma mark - Initialize
// Get Singleton Instance
+ (YHTools *)sharedInstance;

#pragma mark - Debug Mode
- (BOOL)isDevelopMode;

#pragma mark - Handler for UserDefaults
- (id)getUserDefaultsValueWithKey:(NSString *)aKey;
- (void)setUserDefaultsWithObject:(id)obj key:(NSString *)aKey;

#pragma mark - Handler for Image
// Memory Cached Image
- (UIImage *)getImageFromFileNameWithCache:(NSString *)fileName;
- (UIImage *)getImageFromFileNameWithCache:(NSString *)fileName capInsets:(UIEdgeInsets)ei;
- (UIImage *)getImageFromFileNameWithCache:(NSString *)fileName andExt:(NSString *)ext;

// Local Cached Image
- (UIImage *)getImageFromLocalCacheWithFileName:(NSString *)fileName;
- (void)saveImageFileToCacheDirectoryFromURL:(NSString *)urlStr;
- (BOOL)saveImageDataToLocalCacheDirectoryWithImageObj:(UIImage *)img fileName:(NSString *)fileName;

// Set Image To Target ImageView
- (void)setImageToImageView:(UIImageView *)targetImageView
           placeholderImage:(UIImage *)placeholderImage
             imageURLString:(NSString *)imageUrl
          isOnlyMemoryCache:(BOOL)onlyMemoryCache;

- (void)setImageToImageView:(UIImageView *)targetImageView
           placeholderImage:(UIImage *)placeholderImage
             imageURLString:(NSString *)imageUrl
          isOnlyMemoryCache:(BOOL)onlyMemoryCache completion:(void(^)(void))completion;

- (void)setImageToImageView:(UIImageView *)targetImageView
           placeholderImage:(UIImage *)placeholderImage
             imageURLString:(NSString *)imageUrl
            usingLocalCache:(BOOL)useLocalCache
         useChangeAnimation:(BOOL)changeAnimation
                 completion:(void(^)(void))completion;

// Image Resize
- (UIImage * )imageResizeWithImage:(UIImage *)image size:(CGSize)size;

// Get Ratio Height
- (CGFloat)getRatioHeightByWidth:(CGFloat)width originImageSize:(CGSize)imgSize;
- (CGFloat)getRatioHeightByWidth:(CGFloat)width originImage:(UIImage *)image;

// Splash 이미지
- (UIImage *)getSplashImageWithFileName:(NSString *)fileName;

#pragma mark - Handler for Color
// Hex 코드로부터 UIColor 객체 생성
- (UIColor *)getColorByStringHexCode:(NSString *)strHexCode;
- (UIColor *)getColorByStringHexCode:(NSString *)strHexCode alpah:(CGFloat)alpha;

#pragma mark - Handler for Device
// 패드 확인
- (BOOL)isPad;

// 가로 모드 확인
- (BOOL)isLandScapeOrientation;

// Screen Width, Height 확인
- (CGFloat)screenWidthWithConsideredOrientation;
- (CGFloat)screenHeightWithConsideredOrientation;

#pragma mark - App Information
// 앱 버전 확인
- (NSString*)getAppVersion;
- (NSString*)getBuildVersion;

// 사용자 설정 기기 설정 정보
- (void)setLanguageCodeWithCode:(NSString *)lc;
- (NSString *)getLanguageCode;
- (NSString *)getCountryCode;
- (NSString *)getCurrencyCode;
- (NSString *)getCurrencySymbol;
- (void)setCurrencyCode:(NSString *)currencyCode;

#pragma mark - Localized String
- (NSString *)getLocalizedStringWithKey:(NSString *)key;

#pragma mark - Handler for Directory
// Access Local Directory
- (NSString *)getPathOfCacheDirectory;

#pragma mark - Handler for Network
// Make Request Instance For Load WebView
- (NSURLRequest *)makeRequestForLoadWebViewWithURLString:(NSString *)urlStr;

// URL String으로 부터 Request 객체 생성
- (NSURLRequest *)getRequestObjWithURLString:(NSString *)urlStr;
- (NSURLRequest *)getRequestObjWithURLString:(NSString *)urlStr cachePolicy:(NSURLRequestCachePolicy)policy timeoutInterval:(NSTimeInterval)timeoutInterval;
- (NSMutableURLRequest *)getURLRequestWithURLString:(NSString *)url;
- (NSMutableURLRequest *)getURLRequestWithHTTPMethod:(NSString *)methodType
                                                 url:(NSString *)url
                                     parameterString:(NSString *)paramStr
                                          encodeType:(NSString *)encodeType;

// URL Query 정보
- (NSString *)valueInQuery:(NSString *)query key:(NSString *)key;


#pragma mark - Handler for String
// Get String Height
- (CGFloat)getStringHeightWithString:(NSString *)str maxWidth:(CGFloat)maxWidth font:(UIFont *)fontType;
- (CGFloat)getStringHeightWithString:(NSString *)str maxWidth:(CGFloat)maxWidth maxLine:(NSInteger)maxLine font:(UIFont *)fontType; // Height for label line
- (CGFloat)getStringHeightWithString:(NSString *)str maxWidth:(CGFloat)maxWidth font:(UIFont *)fontType lineSpacing:(NSInteger)spacing;
- (CGFloat)getHeightOfAttributedString:(NSString *)str maxWidth:(CGFloat)maxWidth attr:(NSDictionary *)attr;

#pragma mark - Etc Helper
// Generate Random Double Value
- (double)randomFromMinimum: (double) min toMax:(double) max;

// JSON Mapping
- (id)getObjForKeyWithDictionary:(NSDictionary *)dic key:(NSString *)key;

// View Screenshot
- (UIImage *)snapshot:(UIView *)view;

// Convert Json String From Dictionary
- (NSString *)getJsonStringWithDictionary:(NSDictionary *)dic prettyPrint:(BOOL)prettyPrint;

#pragma mark - Handler for SubView Animation
// View Animations
- (void)addModalAnimationWithView:(UIView *)view isPresent:(BOOL)isPresent; // Navigation Controller Custom Transition (Modal)
- (CATransition *)fadeOutAnimationForChangeImage;

#pragma mark - View Draw
- (void)drawSquareLineWithTargetView:(UIView *)targetView
                               Color:(UIColor *)lineColor
                           lineWidth:(CGFloat)lineWidth
                            drawType:(YHDrawSquareType)drawType;


#pragma mark - Handler for Cookies
- (NSArray *)getAllCookies;
- (void)deleteAllCookies;

#pragma mark - JSON String to Object
- (id)convertedObjectWithData:(id)data;

#pragma mark - Google Analytics
- (void)initGA;
- (void)sendGAWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label screenName:(NSString *)screenName;
- (void)sendScreenName:(NSString *)name;

@end
