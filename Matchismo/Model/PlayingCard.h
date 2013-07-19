//
//  PlayingCard.h
//  Matchismo
//
//  Created by Karan Shah on 7/17/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (nonatomic, strong) NSString *suit;

@property (nonatomic) NSInteger rank;

+ (NSArray *)validSuits;

+ (NSUInteger)maxRank;

@end
