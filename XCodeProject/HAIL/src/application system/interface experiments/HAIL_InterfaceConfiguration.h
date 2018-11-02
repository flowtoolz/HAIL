//
//  HAIL_InterfaceConfiguration.h
//  HAIL
//
//  Created by Sebastian on 3/26/13.
//  Copyright (c) 2013 com.hailbringer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface HAIL_InterfaceConfiguration : NSObject

// sound (instrument-) colors of class UIColor
@property (strong, nonatomic) NSMutableArray *soundColorArray;

// singleton access
+ (HAIL_InterfaceConfiguration *)singleton;

@end
