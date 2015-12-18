//
//  EKOriginImage.m
//
//  Created by   on 2015. 11. 18.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "EKOriginImage.h"


NSString *const kEKOriginImageUrl = @"url";
NSString *const kEKOriginImageWidth = @"width";
NSString *const kEKOriginImageHeight = @"height";


@interface EKOriginImage ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation EKOriginImage

@synthesize url = _url;
@synthesize width = _width;
@synthesize height = _height;


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
            self.url = [self objectOrNilForKey:kEKOriginImageUrl fromDictionary:dict];
            self.width = [self objectOrNilForKey:kEKOriginImageWidth fromDictionary:dict];
            self.height = [self objectOrNilForKey:kEKOriginImageHeight fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.url forKey:kEKOriginImageUrl];
    [mutableDict setValue:self.width forKey:kEKOriginImageWidth];
    [mutableDict setValue:self.height forKey:kEKOriginImageHeight];

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

    self.url = [aDecoder decodeObjectForKey:kEKOriginImageUrl];
    self.width = [aDecoder decodeObjectForKey:kEKOriginImageWidth];
    self.height = [aDecoder decodeObjectForKey:kEKOriginImageHeight];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_url forKey:kEKOriginImageUrl];
    [aCoder encodeObject:_width forKey:kEKOriginImageWidth];
    [aCoder encodeObject:_height forKey:kEKOriginImageHeight];
}

- (id)copyWithZone:(NSZone *)zone
{
    EKOriginImage *copy = [[EKOriginImage alloc] init];
    
    if (copy) {

        copy.url = [self.url copyWithZone:zone];
        copy.width = [self.width copyWithZone:zone];
        copy.height = [self.height copyWithZone:zone];
    }
    
    return copy;
}


@end
