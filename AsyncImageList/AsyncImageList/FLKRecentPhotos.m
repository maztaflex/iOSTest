//
//  FLKRecentPhotos.m
//
//  Created by   on 2015. 11. 18.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "FLKRecentPhotos.h"
#import "FLKPhotos.h"
#import "FLKPhoto.h"

NSString *const kFLKRecentPhotosStat = @"stat";
NSString *const kFLKRecentPhotosPhotos = @"photos";


@interface FLKRecentPhotos ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FLKRecentPhotos

@synthesize stat = _stat;
@synthesize photos = _photos;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.stat = [self objectOrNilForKey:kFLKRecentPhotosStat fromDictionary:dict];
            self.photos = [FLKPhotos modelObjectWithDictionary:[dict objectForKey:kFLKRecentPhotosPhotos]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.stat forKey:kFLKRecentPhotosStat];
    [mutableDict setValue:[self.photos dictionaryRepresentation] forKey:kFLKRecentPhotosPhotos];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.stat = [aDecoder decodeObjectForKey:kFLKRecentPhotosStat];
    self.photos = [aDecoder decodeObjectForKey:kFLKRecentPhotosPhotos];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_stat forKey:kFLKRecentPhotosStat];
    [aCoder encodeObject:_photos forKey:kFLKRecentPhotosPhotos];
}

- (id)copyWithZone:(NSZone *)zone
{
    FLKRecentPhotos *copy = [[FLKRecentPhotos alloc] init];
    
    if (copy) {

        copy.stat = [self.stat copyWithZone:zone];
        copy.photos = [self.photos copyWithZone:zone];
    }
    
    return copy;
}

- (void)reqRecentPhotosWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSDictionary *params = @{@"method" : @"flickr.photos.getRecent",
                             @"api_key" : @"a7b7b6ba8cc4213db5f1a773830e07a5",
                             @"format" : @"json",
                             @"extras" : @"url_s",
                             @"nojsoncallback" : @1};
    
    [self.networkManager GET:@"/services/rest" parameters:params success:success failure:failure];
}
- (void)setRecentList:(NSArray *)list
{
    self.photos.photo = @[@"1"];
    
    LogGreen(@"self.photos.photo : %@",self.photos.photo);
}

- (NSArray *)getRecentList
{
    return self.photos.photo;
}

- (NSString *)getThumbnailURLStringAtIndexPath:(NSIndexPath *)indexPath
{
    FLKPhotos *photosObj = self.photos;
    FLKPhoto *photoObj = photosObj.photo[indexPath.row];
    
//    NSString *newUrlS = [photoObj.urlS stringByReplacingOccurrencesOfString:@"m.jpg" withString:@"s.jpg"];
    
//    LogGreen(@"newUrlS : %@",newUrlS);
    
    return photoObj.urlS;
}

- (CGSize)getSizeOfThumbnailPhotoAtIndexPath:(NSIndexPath *)indexPath
{
    FLKPhotos *photosObj = self.photos;
    FLKPhoto *photoObj = photosObj.photo[indexPath.row];
    CGSize photoSize = CGSizeMake(photoObj.widthS.floatValue, photoObj.heightS.floatValue);
    
    return photoSize;
}
@end
