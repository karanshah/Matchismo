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
@property (nonatomic, readwrite) NSString *result;
@end

@implementation CardMatchingGame

@synthesize gameType;

- (NSMutableArray *) cards {
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck {
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
    self.gameType = 2;
    return self;
}



- (Card *)cardAtIndex:(NSUInteger)index {
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

- (void)flipCardAtIndex:(NSUInteger)index {
    Card *card = (Card *)[self cardAtIndex:index];
    if (!card.isUnplayable) {
        if (!card.isFaceUP) {
            NSArray *resultArray = @[@"Flipped up ", card.contents];
            //see if flipping this card up creates a match
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUP && !otherCard.isUnplayable) {
                    NSArray *otherCards = @[otherCard];
                    if (self.gameType == 3) {
                        otherCards = [self getThirdCardToMatch:otherCards];
                    }
                    if(self.gameType == 2 || (self.gameType == 3 && otherCards.count == 2)) {
                        int matchScore = [card match:otherCards];
                        NSMutableString *matchedCardContent = [[NSMutableString alloc] init];
                        if (matchScore) {
                            card.unplayable = YES;
                            matchedCardContent = [self updateOtherCards:otherCards withResult:YES];
//                            otherCard.unplayable = YES;
                            self.score += matchScore * MATCH_BONUS;
                            resultArray = @[@"Matched", matchedCardContent, @"&", card.contents, @"for", [[NSString alloc] initWithFormat:@"%d", matchScore * MATCH_BONUS], @"points"];
                        }
                        else {
                            matchedCardContent = [self updateOtherCards:otherCards withResult:NO];
                            self.score -= MISMATCH_PENALTY;
                            resultArray = @[matchedCardContent, @"&", card.contents, @"don't", @"match!", [[NSString alloc] initWithFormat:@"%d", MISMATCH_PENALTY], @"point penalty!"];
                        }
                    }
                    
                }
            }
            self.score -= FLIP_COST;
            self.result = [resultArray componentsJoinedByString:@" "];
        }
        card.faceUp = !card.faceUp;
    }
}

- (NSMutableString *) updateOtherCards:(NSArray *)otherCards
               withResult:(BOOL)result {
    NSMutableString *otherCardContent = [[NSMutableString alloc] init];
    int i = 0;
    for (Card *otherCard in otherCards) {
        if (result) {
            otherCard.unplayable = YES;
        }
        else {
            otherCard.faceUp = NO;
        }
        [otherCardContent appendString:otherCard.contents];
        i++;
        if (i < otherCards.count) {
            [otherCardContent appendString:@", "];
        }
    }
    return otherCardContent;
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

@end
