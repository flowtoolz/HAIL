//
//  HAIL_InterfaceConfiguration.m
//  HAIL
//
//  Created by Sebastian on 3/26/13.
//  Copyright (c) 2013 com.hailbringer. All rights reserved.
//

#import "HAIL_InterfaceConfiguration.h"

@implementation HAIL_InterfaceConfiguration

{}
#pragma mark - Sound Colors

- (void)addSoundColorWithRed:(float)red
					   green:(float)green
						blue:(float)blue
{
	UIColor *color = [UIColor colorWithRed:red
									 green:green
									  blue:blue
									 alpha:1.0];
	
	[[self soundColorArray] addObject:color];
}

- (void)generatSoundColors
{
	float val[] = {1.0 / 8, 4.0 / 8, 7.0 / 8};
	
	[self addSoundColorWithRed:val[0] green:val[1] blue:val[2]];
	[self addSoundColorWithRed:val[1] green:val[0] blue:val[2]];
	[self addSoundColorWithRed:val[2] green:val[0] blue:val[1]];
	[self addSoundColorWithRed:val[2] green:val[1] blue:val[0]];
	[self addSoundColorWithRed:val[1] green:val[2] blue:val[0]];
	[self addSoundColorWithRed:val[0] green:val[2] blue:val[1]];
}

- (NSMutableArray *)soundColorArray
{
	if (!_soundColorArray)
	{
		_soundColorArray = [NSMutableArray array];
		
		[self generatSoundColors];
	}
	
	return _soundColorArray;
}

#pragma mark - Singleton Access

+ (HAIL_InterfaceConfiguration *)singleton
{
	static HAIL_InterfaceConfiguration *interfaceConfig = nil;
	
	if (!interfaceConfig) interfaceConfig = [[super allocWithZone:nil] init];
	
	return interfaceConfig;
}

+ (id)allocWithZone:(NSZone *)zone
{
	return [self singleton];
}

@end
