//
//  FLKPhoto.h
//
//  Created by   on 2015. 11. 18.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface FLKPhoto : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *secret;
@property (nonatomic, strong) NSString *photoIdentifier;
@property (nonatomic, assign) double isfamily;
@property (nonatomic, assign) double ispublic;
@property (nonatomic, assign) double farm;
@property (nonatomic, strong) NSString *owner;
@property (nonatomic, strong) NSString *server;
@property (nonatomic, strong) NSString *urlM;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) double isfriend;
@property (nonatomic, strong) NSString *heightM;
@property (nonatomic, strong) NSString *widthM;
@property (nonatomic, strong) NSString *heightS;
@property (nonatomic, strong) NSString *widthS;
@property (nonatomic, strong) NSString *urlS;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
