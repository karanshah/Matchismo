//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Karan Shah on 7/19/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCard.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) NSString *result;
@end

@implementation CardMatchingGame

- (NSMutableArray *) cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck {
    self = [super init];
    
    if(self) {
        for (int i = 0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            if(card) {
                self.cards[i] = card;
            }
            else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index {
    PlayingCard *card = (PlayingCard *)[self cardAtIndex:index];
    if (!card.isUnplayable) {
        if (!card.isFaceUP) {
            NSArray *resultArray = @[@"Flipped up ", card.contents];
            //see if flipping this card up creates a match
            for (PlayingCard *otherCard in self.cards) {
                if (otherCard.isFaceUP && !otherCard.isUnplayable) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        resultArray = @[@"Matched", card.contents, @"&", otherCard.contents, @"for", [[NSString alloc] initWithFormat:@"%d", matchScore * MATCH_BONUS], @"points"];
                    }
                    else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        resultArray = @[card.contents, @"&", otherCard.contents, @"don't", @"match!", [[NSString alloc] initWithFormat:@"%d", MISMATCH_PENALTY], @"point penalty!"];
                    }
                }
            }
            self.score -= FLIP_COST;
            self.result = [resultArray componentsJoinedByString:@" "];
        }
        card.faceUp = !card.faceUp;
    }
}

@end
