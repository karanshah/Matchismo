//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Karan Shah on 7/19/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

//designated initializer
- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readonly) int score;

@property (nonatomic, readonly) NSString *result;

@end
