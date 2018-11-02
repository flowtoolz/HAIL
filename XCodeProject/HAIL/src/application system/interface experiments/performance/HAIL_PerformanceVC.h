//
//  HAIL_PerformanceViewController.h
//  HAIL
//
//  Created by Sebastian on 2/28/13.
//  Copyright (c) 2013 com.hailbringer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "HAIL_PerformanceViewOLD.h"

@interface HAIL_PerformanceVC : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) HAIL_PerformanceViewOLD *performanceView;

@end
