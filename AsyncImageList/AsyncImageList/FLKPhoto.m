//
//  FLKPhoto.m
//
//  Created by   on 2015. 11. 18.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import "FLKPhoto.h"


NSString *const kFLKPhotoSecret = @"secret";
NSString *const kFLKPhotoId = @"id";
NSString *const kFLKPhotoIsfamily = @"isfamily";
NSString *const kFLKPhotoIspublic = @"ispublic";
NSString *const kFLKPhotoFarm = @"farm";
NSString *const kFLKPhotoOwner = @"owner";
NSString *const kFLKPhotoServer = @"server";
NSString *const kFLKPhotoUrlM = @"url_m";
NSString *const kFLKPhotoTitle = @"title";
NSString *const kFLKPhotoIsfriend = @"isfriend";
NSString *const kFLKPhotoHeightM = @"height_m";
NSString *const kFLKPhotoWidthM = @"width_m";


@interface FLKPhoto ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation FLKPhoto

@synthesize secret = _secret;
@synthesize photoIdentifier = _photoIdentifier;
@synthesize isfamily = _isfamily;
@synthesize ispublic = _ispublic;
@synthesize farm = _farm;
@synthesize owner = _owner;
@synthesize server = _server;
@synthesize urlM = _urlM;
@synthesize title = _title;
@synthesize isfriend = _isfriend;
@synthesize heightM = _heightM;
@synthesize widthM = _widthM;


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
            self.secret = [self objectOrNilForKey:kFLKPhotoSecret fromDictionary:dict];
            self.photoIdentifier = [self objectOrNilForKey:kFLKPhotoId fromDictionary:dict];
            self.isfamily = [[self objectOrNilForKey:kFLKPhotoIsfamily fromDictionary:dict] doubleValue];
            self.ispublic = [[self objectOrNilForKey:kFLKPhotoIspublic fromDictionary:dict] doubleValue];
            self.farm = [[self objectOrNilForKey:kFLKPhotoFarm fromDictionary:dict] doubleValue];
            self.owner = [self objectOrNilForKey:kFLKPhotoOwner fromDictionary:dict];
            self.server = [self objectOrNilForKey:kFLKPhotoServer fromDictionary:dict];
            self.urlM = [self objectOrNilForKey:kFLKPhotoUrlM fromDictionary:dict];
            self.title = [self objectOrNilForKey:kFLKPhotoTitle fromDictionary:dict];
            self.isfriend = [[self objectOrNilForKey:kFLKPhotoIsfriend fromDictionary:dict] doubleValue];
            self.heightM = [self objectOrNilForKey:kFLKPhotoHeightM fromDictionary:dict];
            self.widthM = [self objectOrNilForKey:kFLKPhotoWidthM fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.secret forKey:kFLKPhotoSecret];
    [mutableDict setValue:self.photoIdentifier forKey:kFLKPhotoId];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isfamily] forKey:kFLKPhotoIsfamily];
    [mutableDict setValue:[NSNumber numberWithDouble:self.ispublic] forKey:kFLKPhotoIspublic];
    [mutableDict setValue:[NSNumber numberWithDouble:self.farm] forKey:kFLKPhotoFarm];
    [mutableDict setValue:self.owner forKey:kFLKPhotoOwner];
    [mutableDict setValue:self.server forKey:kFLKPhotoServer];
    [mutableDict setValue:self.urlM forKey:kFLKPhotoUrlM];
    [mutableDict setValue:self.title forKey:kFLKPhotoTitle];
    [mutableDict setValue:[NSNumber numberWithDouble:self.isfriend] forKey:kFLKPhotoIsfriend];
    [mutableDict setValue:self.heightM forKey:kFLKPhotoHeightM];
    [mutableDict setValue:self.widthM forKey:kFLKPhotoWidthM];

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

    self.secret = [aDecoder decodeObjectForKey:kFLKPhotoSecret];
    self.photoIdentifier = [aDecoder decodeObjectForKey:kFLKPhotoId];
    self.isfamily = [aDecoder decodeDoubleForKey:kFLKPhotoIsfamily];
    self.ispublic = [aDecoder decodeDoubleForKey:kFLKPhotoIspublic];
    self.farm = [aDecoder decodeDoubleForKey:kFLKPhotoFarm];
    self.owner = [aDecoder decodeObjectForKey:kFLKPhotoOwner];
    self.server = [aDecoder decodeObjectForKey:kFLKPhotoServer];
    self.urlM = [aDecoder decodeObjectForKey:kFLKPhotoUrlM];
    self.title = [aDecoder decodeObjectForKey:kFLKPhotoTitle];
    self.isfriend = [aDecoder decodeDoubleForKey:kFLKPhotoIsfriend];
    self.heightM = [aDecoder decodeObjectForKey:kFLKPhotoHeightM];
    self.widthM = [aDecoder decodeObjectForKey:kFLKPhotoWidthM];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_secret forKey:kFLKPhotoSecret];
    [aCoder encodeObject:_photoIdentifier forKey:kFLKPhotoId];
    [aCoder encodeDouble:_isfamily forKey:kFLKPhotoIsfamily];
    [aCoder encodeDouble:_ispublic forKey:kFLKPhotoIspublic];
    [aCoder encodeDouble:_farm forKey:kFLKPhotoFarm];
    [aCoder encodeObject:_owner forKey:kFLKPhotoOwner];
    [aCoder encodeObject:_server forKey:kFLKPhotoServer];
    [aCoder encodeObject:_urlM forKey:kFLKPhotoUrlM];
    [aCoder encodeObject:_title forKey:kFLKPhotoTitle];
    [aCoder encodeDouble:_isfriend forKey:kFLKPhotoIsfriend];
    [aCoder encodeObject:_heightM forKey:kFLKPhotoHeightM];
    [aCoder encodeObject:_widthM forKey:kFLKPhotoWidthM];
}

- (id)copyWithZone:(NSZone *)zone
{
    FLKPhoto *copy = [[FLKPhoto alloc] init];
    
    if (copy) {

        copy.secret = [self.secret copyWithZone:zone];
        copy.photoIdentifier = [self.photoIdentifier copyWithZone:zone];
        copy.isfamily = self.isfamily;
        copy.ispublic = self.ispublic;
        copy.farm = self.farm;
        copy.owner = [self.owner copyWithZone:zone];
        copy.server = [self.server copyWithZone:zone];
        copy.urlM = [self.urlM copyWithZone:zone];
        copy.title = [self.title copyWithZone:zone];
        copy.isfriend = self.isfriend;
        copy.heightM = [self.heightM copyWithZone:zone];
        copy.widthM = [self.widthM copyWithZone:zone];
    }
    
    return copy;
}


@end
