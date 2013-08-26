//
//  SetCard.m
//  Matchismo
//
//  Created by Karan Shah on 7/27/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (int) match:(NSArray *)otherCards {
    int score = 4;
    
    NSMutableArray *cards = [[NSMutableArray alloc] initWithArray:otherCards];
    [cards addObject:self];
    
    NSMutableSet *numberSet = [[NSMutableSet alloc] init];
    NSMutableSet *symbolSet = [[NSMutableSet alloc] init];
    NSMutableSet *shadingSet = [[NSMutableSet alloc] init];
    NSMutableSet *colorSet = [[NSMutableSet alloc] init];
    
    for (SetCard *card in cards) {
        [numberSet addObject:[[NSNumber alloc] initWithInt:card.number]];
        [symbolSet addObject:card.symbol];
        [shadingSet addObject:card.shading];
        [colorSet addObject:card.color];
    }
    
    if (numberSet.count == 2 || symbolSet.count == 2 || shadingSet.count == 2 || colorSet.count == 2) {
        score = 0;
    }
    
    return score;
}

- (NSString *)contents {
    NSString *content = @"";
    for (int i = 0; i < self.number; i++) {
        content = [content stringByAppendingString:self.symbol];
    }
    return content;
}

+ (NSArray *) validColors {
    return @[@"red", @"blue", @"green"];
}

+ (NSArray *) validShadings {
    return @[@"open", @"stripped", @"solid"];
}

+ (NSArray *) validSymbols {
    return @[@"diamond", @"oval", @"squiggle"];
}

@end
