//
//  YHConfig.h
//
//  Created by DEV_TEAM1_IOS on 2015. 8. 25..
//  Copyright (c) 2015년 S.M Entertainment. All rights reserved.
//

#ifndef YHConfig_h
#define YHConfig_h

// Network
#define REQ_BASE_URL                @""

// Google Analytics
#if DEBUG
    #define GA_TRACKER_ID                           @""
#elif RELEASE || INHOUSE
    #define GA_TRACKER_ID                           @""
#endif

// NSUserDefault Key For User Preference
#define kHasBeenLaunched                            @"hasBeenLaunced"
#define kSettingLanguageCode                        @"languageCode"
#define kSettingCurrencyCode                        @"currencyCode"
#define kIsRegisgeredRemotePush                     @"isRegisteredPush"
#define kEnabledPushSetting                         @"enabledPushSetting"

// Parse.com (SUMProject)
#define kParseAppId                                 @"hdAzJJ1j3HnmMfmM1v8149CHz3lPWqz39iMc2ww2"
#define kParseClientKey                             @"KLCbS9sktidOnKLYFDInKtKIKBAnfOiBttiGg246"

// NotificationCenter Names
#define YHGoogleLoginSuccessNotification            @"yh.google.login.success"
#define YHShouldGooglePlusInstallNotification       @"yh.google.plus.install"
#define YHApplicationOpenGoogleAuthNotification     @"yh.open.google.auth"
#define YHShouldStartShareGooglePlusNotification    @"yh.start.google.share"

// ===================================== Local Notification Identifier ===================================================
#define SMPSplashViewTaskDoneNotification                       @"com.everysingkorea.splashtask.done"
#define SMPRequestSpecialListDoneNotification                   @"com.everysingkorea.reqSpecialList.done"
#define SMPRequestOpenListDoneNotification                      @"com.everysingkorea.reqOpenList.done"
#define SMPMainListDidScrollNotification                        @"com.everysingkorea.mainList.scroll"
#define SMPRequestProjectCountInfoDoneNotification              @"com.everysingkorea.reqProjectInfo.done"
#define SMPRequestClosedListDoneNotification                    @"com.everysingkorea.reqClosedList.done"
#define SMPOrderbyMenuDidSelectNotification                     @"com.everysingkorea.orderbyMenu.selected"
#define SMPShouldRefreshOpenListNotification                    @"com.everysingkorea.openlist.refresh"
#define SMPShouldRefreshClosedListNotification                  @"com.everysingkorea.closedlist.refresh"
#define SMPShouldRefreshSpecialListNotification                 @"com.everysingkorea.speciallist.refresh"
#define SMPShouldDeleteOptionNotification                       @"com.everysingkorea.delete.option"
#define SMPTouchedOptionMinusButtonNotification                 @"com.everysingkorea.touched.minus"
#define SMPTouchedOptionPlusButtonNotification                  @"com.everysingkorea.touched.plus"
#define SMPShouldAllRefreshNotification                         @"com.everysingkorea.all.refresh"
#define SMPShouldAllWebViewRefreshNotification                  @"com.everysingkorea.allwebview.refresh"
#define SMPMainMenuStatusChangedBySpeicalNotification           @"com.everysingkorea.special.menu.changed"
#define SMPShouldRefreshMainMenuListNotification                @"com.everysingkorea.mainmenu.refresh"
#define SMPShouldFirstProgressOpenListNotification              @"com.everysingkorea.first.progress.open.list"
#define SMPShouldFirstProgressClosedListNotification            @"com.everysingkorea.first.progress.closed.list"

#endif
