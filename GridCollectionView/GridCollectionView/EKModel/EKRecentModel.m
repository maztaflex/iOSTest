//
//  EKRecentModel.m
//
//  Created by   on 2015. 11. 18.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "EKRecentModel.h"
#import "EKThumbnailImage.h"
#import "EKOriginImage.h"
#import "EKThumbnailImage.h"

NSString *const kEKRecentModelKey = @"key";
NSString *const kEKRecentModelThumbnailImage = @"thumbnailImage";
NSString *const kEKRecentModelOriginImage = @"originImage";


@interface EKRecentModel ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation EKRecentModel

@synthesize key = _key;
@synthesize thumbnailImage = _thumbnailImage;
@synthesize originImage = _originImage;


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
            self.key = [self objectOrNilForKey:kEKRecentModelKey fromDictionary:dict];
            self.thumbnailImage = [EKThumbnailImage modelObjectWithDictionary:[dict objectForKey:kEKRecentModelThumbnailImage]];
            self.originImage = [EKOriginImage modelObjectWithDictionary:[dict objectForKey:kEKRecentModelOriginImage]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.key forKey:kEKRecentModelKey];
    [mutableDict setValue:[self.thumbnailImage dictionaryRepresentation] forKey:kEKRecentModelThumbnailImage];
    [mutableDict setValue:[self.originImage dictionaryRepresentation] forKey:kEKRecentModelOriginImage];

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

    self.key = [aDecoder decodeObjectForKey:kEKRecentModelKey];
    self.thumbnailImage = [aDecoder decodeObjectForKey:kEKRecentModelThumbnailImage];
    self.originImage = [aDecoder decodeObjectForKey:kEKRecentModelOriginImage];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_key forKey:kEKRecentModelKey];
    [aCoder encodeObject:_thumbnailImage forKey:kEKRecentModelThumbnailImage];
    [aCoder encodeObject:_originImage forKey:kEKRecentModelOriginImage];
}

- (id)copyWithZone:(NSZone *)zone
{
    EKRecentModel *copy = [[EKRecentModel alloc] init];
    
    if (copy) {

        copy.key = [self.key copyWithZone:zone];
        copy.thumbnailImage = [self.thumbnailImage copyWithZone:zone];
        copy.originImage = [self.originImage copyWithZone:zone];
    }
    
    return copy;
}

#pragma mark - Request
- (void)requestRecentPhotosWithLastKey:(NSString *)key
                           Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    self.networkManager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *params = @{@"lastEvaluateKey" : ((key == nil) ? [NSNull null] : key)};
    // https://y3zhm4ntme.execute-api.ap-northeast-1.amazonaws.com/prod2
    [self.networkManager POST:@"https://y3zhm4ntme.execute-api.ap-northeast-1.amazonaws.com/prod2" parameters:params success:success failure:false];
}

#pragma mark - Get Data
- (NSString *)getThumbnailURLString
{
    NSString *result = nil;
    
    result = self.thumbnailImage.url;
    
    return result;
}

- (CGSize)getThumbnailSize
{
    CGSize result = CGSizeZero;
    
    result = CGSizeMake(self.thumbnailImage.width.floatValue, self.thumbnailImage.height.floatValue);
    
    return result;
}

@end
