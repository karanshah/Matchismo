//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Karan Shah on 7/19/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import "CardMatchingGame.h"
//#import "Card.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic, readwrite) int score;
@end

@implementation CardMatchingGame

@synthesize gameType;

- (NSMutableArray *) cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck
           withGameType:(NSInteger)typeOfGame {
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
    self.gameType = typeOfGame;
    return self;
}



- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (NSArray *)flipCardAtIndex:(NSUInteger)index {
    NSArray *resultArray = nil;
    Card *card = (Card *)[self cardAtIndex:index];
    if (!card.isUnplayable) {
        if (!card.isFaceUP) {
            resultArray = @[@"Flipped up ", card];
            //see if flipping this card up creates a match
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUP && !otherCard.isUnplayable) {
                    NSArray *otherCards = @[otherCard];
                    if (self.gameType == 3) {
                        otherCards = [self getThirdCardToMatch:otherCards];
                    }
                    if(self.gameType == 2 || (self.gameType == 3 && otherCards.count == 2)) {
                        int matchScore = [card match:otherCards];
                        if (matchScore) {
                            card.unplayable = YES;
                            [self updateOtherCards:otherCards withResult:YES];
                            self.score += matchScore * MATCH_BONUS;
                            resultArray = @[@"Matched", otherCards, @"&", card, @"for", [[NSString alloc] initWithFormat:@"%d", matchScore * MATCH_BONUS], @"points"];
                        }
                        else {
                            [self updateOtherCards:otherCards withResult:NO];
                            self.score -= MISMATCH_PENALTY;
                            resultArray = @[otherCards, @"&", card, @"don't", @"match!", [[NSString alloc] initWithFormat:@"%d", MISMATCH_PENALTY], @"point penalty!"];
                        }
                    }
                    
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.faceUp;
    }
    return resultArray;
}

- (void)removeCardAtIndex:(NSUInteger)index
{
    if (index < [self.cards count]) {
        [self.cards removeObjectAtIndex:index];
    }
}

- (void) updateOtherCards:(NSArray *)otherCards
               withResult:(BOOL)result {
    for (Card *otherCard in otherCards) {
        if (result) {
            otherCard.unplayable = YES;
        }
        else {
            otherCard.faceUp = NO;
        }    
    }
}

- (NSArray *) getThirdCardToMatch:(NSArray *)otherCards {
    Card *otherCard = [otherCards lastObject];
    for (Card *thirdCard in self.cards) {
        if (thirdCard.isFaceUP && !thirdCard.isUnplayable) {
            if (![otherCard isEqual:thirdCard]) {
                return @[otherCard, thirdCard];
            }
        }
    }
    return otherCards;
}

- (NSUInteger) cardCount {
    return self.cards.count;
}

@end
