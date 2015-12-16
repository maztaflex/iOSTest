//
//  FLKPhotos.m
//
//  Created by   on 2015. 11. 18.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "FLKPhotos.h"
#import "FLKPhoto.h"


NSString *const kFLKPhotosPhoto = @"photo";
NSString *const kFLKPhotosPages = @"pages";
NSString *const kFLKPhotosPerpage = @"perpage";
NSString *const kFLKPhotosTotal = @"total";
NSString *const kFLKPhotosPage = @"page";


@interface FLKPhotos ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FLKPhotos

@synthesize photo = _photo;
@synthesize pages = _pages;
@synthesize perpage = _perpage;
@synthesize total = _total;
@synthesize page = _page;


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
    NSObject *receivedFLKPhoto = [dict objectForKey:kFLKPhotosPhoto];
    NSMutableArray *parsedFLKPhoto = [NSMutableArray array];
    if ([receivedFLKPhoto isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedFLKPhoto) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedFLKPhoto addObject:[FLKPhoto modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedFLKPhoto isKindOfClass:[NSDictionary class]]) {
       [parsedFLKPhoto addObject:[FLKPhoto modelObjectWithDictionary:(NSDictionary *)receivedFLKPhoto]];
    }

    self.photo = [NSArray arrayWithArray:parsedFLKPhoto];
            self.pages = [[self objectOrNilForKey:kFLKPhotosPages fromDictionary:dict] doubleValue];
            self.perpage = [[self objectOrNilForKey:kFLKPhotosPerpage fromDictionary:dict] doubleValue];
            self.total = [[self objectOrNilForKey:kFLKPhotosTotal fromDictionary:dict] doubleValue];
            self.page = [[self objectOrNilForKey:kFLKPhotosPage fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForPhoto = [NSMutableArray array];
    for (NSObject *subArrayObject in self.photo) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForPhoto addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForPhoto addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForPhoto] forKey:kFLKPhotosPhoto];
    [mutableDict setValue:[NSNumber numberWithDouble:self.pages] forKey:kFLKPhotosPages];
    [mutableDict setValue:[NSNumber numberWithDouble:self.perpage] forKey:kFLKPhotosPerpage];
    [mutableDict setValue:[NSNumber numberWithDouble:self.total] forKey:kFLKPhotosTotal];
    [mutableDict setValue:[NSNumber numberWithDouble:self.page] forKey:kFLKPhotosPage];

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

    self.photo = [aDecoder decodeObjectForKey:kFLKPhotosPhoto];
    self.pages = [aDecoder decodeDoubleForKey:kFLKPhotosPages];
    self.perpage = [aDecoder decodeDoubleForKey:kFLKPhotosPerpage];
    self.total = [aDecoder decodeDoubleForKey:kFLKPhotosTotal];
    self.page = [aDecoder decodeDoubleForKey:kFLKPhotosPage];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_photo forKey:kFLKPhotosPhoto];
    [aCoder encodeDouble:_pages forKey:kFLKPhotosPages];
    [aCoder encodeDouble:_perpage forKey:kFLKPhotosPerpage];
    [aCoder encodeDouble:_total forKey:kFLKPhotosTotal];
    [aCoder encodeDouble:_page forKey:kFLKPhotosPage];
}

- (id)copyWithZone:(NSZone *)zone
{
    FLKPhotos *copy = [[FLKPhotos alloc] init];
    
    if (copy) {

        copy.photo = [self.photo copyWithZone:zone];
        copy.pages = self.pages;
        copy.perpage = self.perpage;
        copy.total = self.total;
        copy.page = self.page;
    }
    
    return copy;
}


@end
