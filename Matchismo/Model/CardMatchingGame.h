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
              usingDeck:(Deck *)deck
           withGameType:(NSInteger) typeOfGame;

- (NSArray *)flipCardAtIndex:(NSUInteger)index;
- (void)removeCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

- (NSUInteger) cardCount;

- (BOOL) addCardsWithCount:(NSUInteger)cardCount
                 usingDeck:(Deck *)deck
               intialIndex:(NSUInteger) index;

@property (nonatomic, readonly) int score;

@property (nonatomic) NSInteger gameType;

@end
