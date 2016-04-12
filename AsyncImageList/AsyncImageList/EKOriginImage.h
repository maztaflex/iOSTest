//
//  EKOriginImage.h
//
//  Created by   on 2015. 11. 18.
//  Copyright (c) 2015 __MyCompanyName__. All rights reserved....
//

#import <Foundation/Foundation.h>



@interface EKOriginImage : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *height;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
