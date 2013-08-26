//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Karan Shah on 7/27/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardCollectionViewCell.h"
#import "SetCardView.h"

@interface SetCardGameViewController ()
@property (strong, nonatomic) Deck *deck;
@end

@implementation SetCardGameViewController

- (Deck *) deck {
    if(!_deck) {
        _deck = [[SetCardDeck alloc] init];
    }
    return _deck;
}

- (void) updateGame:(NSArray *)cardButtons {
    for (UIButton *cardButton in cardButtons) {
        Card *card = [self.game cardAtIndex:[cardButtons indexOfObject:cardButton]];
        NSAttributedString *cardAttributedTitle = [[NSAttributedString alloc] initWithString:[card contents] attributes:[self getCardAttributes:card]];
        [cardButton setAttributedTitle:cardAttributedTitle forState:UIControlStateNormal];
        [cardButton setBackgroundColor:(card.isFaceUP) ? [UIColor lightGrayColor] : nil];
        cardButton.alpha = card.isUnplayable ? 0.0 : 1.0;
    }
}

- (void) updateCell:(UICollectionViewCell *)cell
          usingCard:(Card *)card {
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *) cell).setCardView;
        if([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            setCardView.symbol = setCard.symbol;
            setCardView.shading = setCard.shading;
            setCardView.color = setCard.color;
            setCardView.number = setCard.number;
            setCardView.faceUp = setCard.faceUp;
        }
    }
}

- (NSUInteger) startingCardCount {
    return 12;
}

- (NSString *) reusableCellId {
    return @"SetCard";
}

@synthesize gameType = _gameType;

- (NSInteger) gameType {
    if (!_gameType) {
        _gameType = 3;
    }
    return _gameType;
}


- (NSDictionary *) getCardAttributes:(Card *)card {
    NSDictionary *attributeDictionary = nil;
    UIColor *color = nil;
    
    if ([card isKindOfClass:[SetCard class]]) {
        SetCard *setCard = (SetCard *) card;
        
        if ([setCard.color isEqualToString:@"red"]) {
            color = [UIColor redColor];
        }
        else if ([setCard.color isEqualToString:@"blue"]) {
            color = [UIColor blueColor];
        }
        else if ([setCard.color isEqualToString:@"green"]) {
            color = [UIColor greenColor];
        }
        
        if ([setCard.shading isEqualToString:@"solid"]) {
            attributeDictionary = @{NSForegroundColorAttributeName: color};
        }
        else if ([setCard.shading isEqualToString:@"stripped"]) {
            attributeDictionary = @{NSStrokeColorAttributeName: color,
                                    NSStrokeWidthAttributeName: @(-5),
                                    NSForegroundColorAttributeName:[color colorWithAlphaComponent:0.2F]};
        }
        else if ([setCard.shading isEqualToString:@"open"]) {
            attributeDictionary = @{NSStrokeColorAttributeName: color,NSStrokeWidthAttributeName: @(5)};
        }
    }
    
    return attributeDictionary;
}


@end
