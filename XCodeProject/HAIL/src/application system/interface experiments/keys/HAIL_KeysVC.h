//
//  HAIL_PianoViewController.h
//  HAIL
//
//  Created by Sebastian on 2/27/13.
//  Copyright (c) 2013 com.hailbringer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "HAIL_KeysView.h"

@interface HAIL_KeysVC : UIViewController

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) HAIL_KeysView *pianoView;

@end
