//
//  YHLayout.h
//
//  Created by DEV_TEAM1_IOS on 2015. 9. 7..
//  Copyright (c) 2015년 S.M Entertainment. All rights reserved.
//

#ifndef SUMPreOrder_YHLayout_h
#define SUMPreOrder_YHLayout_h

typedef NS_ENUM(NSInteger, YHViewTransitionType)
{
    YHViewTransitionTypeModal = 20000,
    YHViewTransitionTypePush,
};

// Device Screen Size
#define SCREEN_WIDTH_OF_IPHONE_4            320.0f
#define SCREEN_WIDTH_OF_IPHONE_5            320.0f
#define SCREEN_WIDTH_OF_IPHONE_6            375.0f
#define SCREEN_WIDTH_OF_IPHONE_6PLUS        414.0f
#define SCREEN_WIDTH_OF_IPAD                768.0f
#define SCREEN_HEIGHT_OF_IPHONE_4           480.0f
#define SCREEN_HEIGHT_OF_IPHONE_5           568.0f
#define SCREEN_HEIGHT_OF_IPHONE_6           667.0f
#define SCREEN_HEIGHT_OF_IPHONE_6PLUS       736.0f
#define SCREEN_HEIGHT_OF_IPAD               1024.0f

// System Layout Sizes
#define STATUS_BAR_HEIGHT                   20.0f

// Calculate Size By Ratio (Standard Device = iPhone6plus)
#define SCREEN_HEIGHT                                 [self.tools screenHeightWithConsideredOrientation]
#define SCREEN_WIDTH                                  [self.tools screenWidthWithConsideredOrientation]
#define WRATIO_SIZE(standardSize)                      standardSize * (SCREEN_WIDTH / SCREEN_WIDTH_OF_IPHONE_6PLUS)
#define HRATIO_SIZE(standardSize)                      standardSize * (SCREEN_HEIGHT / SCREEN_HEIGHT_OF_IPHONE_6PLUS)

#define DEFAULT_ANIMATION_DURATION                       0.32f

// Color
#define CLC_BEBEBE                          @"bebebe"
#define CLC_FFFFFF                          @"ffffff"
#define CLC_535353                          @"535353"
#define CLC_343738                          @"343738"
#define CLC_2D2E30                          @"2d2e30"
#define CLC_747474                          @"747474"
#define CLC_141414                          @"141414"
#define CLC_DCDCDC                          @"dcdcdc"
#define CLC_E53A7B                          @"e53a7b"
#define CLC_E33E7C                          @"e33e7c"
#define CLC_4B4B4B                          @"4b4b4b"
#define CLC_4C4C4C                          @"4c4c4c"
#define CLC_B2B2B2                          @"b2b2b2"
#define CLC_DCDCDC                          @"dcdcdc"
#define CLC_F5F5F5                          @"f5f5f5"
#define CLC_FBFBFB                          @"fbfbfb"
#define CLC_6B6B6B                          @"6b6b6b"
#define CLC_E33D7D                          @"e33d7d"
#define CLC_CACACC                          @"cacacc"

// Font Type and Size
#define YH_FONT_HELVETICANEUE(fontSize)             [UIFont fontWithName:@"HelveticaNeue" size:fontSize]
#define YH_FONT_HELVETICANEUE_BOLD(fontSize)        [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize]
#define YH_FONT_AVENIR_ROMAN(fontSize)              [UIFont fontWithName:@"Avenir-Roman" size:fontSize]
#define YH_FONT_AVENIR_HEAVY(fontSize)              [UIFont fontWithName:@"Avenir-Heavy" size:fontSize]
#define YH_FONT_HIRAKAKUPRON_W6(fontSize)           [UIFont fontWithName:@"HiraKakuProN-W6" size:fontSize] 



#endif
