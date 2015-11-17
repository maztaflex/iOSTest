//
//  FLKRecentPhotos.h
//
//  Created by   on 2015. 11. 18.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FLKPhotos;

@interface FLKRecentPhotos : YHModel <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *stat;
@property (nonatomic, strong) FLKPhotos *photos;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

- (void)reqRecentPhotosWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (NSString *)getThumbnailURLStringAtIndexPath:(NSIndexPath *)indexPath;
- (CGSize)getSizeOfThumbnailPhotoAtIndexPath:(NSIndexPath *)indexPath;

@end
