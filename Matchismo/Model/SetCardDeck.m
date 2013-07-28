//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Karan Shah on 7/27/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id) init {
    self = [super init];
    
    if(self) {
        for (NSUInteger num = 1; num <= 3; num++) {
            for (NSString *color in [SetCard validColors]) {
                for (NSString *shading in [SetCard validShadings]) {
                    for (NSString *symbol in [SetCard validSymbols]) {
                        SetCard *card = [[SetCard alloc] init];
                        card.symbol = symbol;
                        card.shading = shading;
                        card.color = color;
                        card.number = num;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
