//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Karan Shah on 7/30/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

@property (nonatomic) BOOL faceUp;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
