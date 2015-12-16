//
//  FLKPhotos.h
//
//  Created by   on 2015. 11. 18.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface FLKPhotos : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *photo;
@property (nonatomic, assign) double pages;
@property (nonatomic, assign) double perpage;
@property (nonatomic, assign) double total;
@property (nonatomic, assign) double page;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
