//
//  SetCard.m
//  Matchismo
//
//  Created by Karan Shah on 7/27/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

//- (int) match:(NSArray *)otherCards {
//    
//}

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
    return @[@"▲", @"●", @"■"];
}

@end
