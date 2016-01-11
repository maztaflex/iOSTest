//
//  EKRecentModel.h
//
//  Created by   on 2015. 11. 18.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EKOriginImage, EKThumbnailImage;

@interface EKRecentModel : YHModel <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) EKThumbnailImage *thumbnailImage;
@property (nonatomic, strong) EKOriginImage *originImage;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

#pragma mark - Request
- (void)requestRecentPhotosWithLastKey:(NSString *)key
                               Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - Get Data
- (NSString *)getThumbnailURLString;
- (CGSize)getThumbnailSize;

@end
