//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Karan Shah on 7/17/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) CardMatchingGame *game;
@property (nonatomic) NSInteger gameType;

- (void) updateGame:(NSArray*) cardButtons;
- (NSDictionary *) getCardAttributes:(Card *)card;

@end
