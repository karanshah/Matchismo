//
//  SetCardView.h
//  Matchismo
//
//  Created by Karan Shah on 7/30/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

//Should be 0, 1, 2 or 3
@property (nonatomic) NSInteger number;

//Should be @"diamond", @"oval" or @"squiggle"
@property (nonatomic, strong) NSString *symbol;

//Should be @"open", @"stripped" or @"solid"
@property (nonatomic, strong) NSString *shading;

//Should be @"red", @"blue" or @"green"
@property (nonatomic, strong) NSString *color;

@property (nonatomic) BOOL faceUp;

@end
