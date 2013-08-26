//
//  MatchCardGameViewController.m
//  Matchismo
//
//  Created by Karan Shah on 7/26/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import "MatchCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardCollectionViewCell.h"
#import "PlayingCard.h"

@interface MatchCardGameViewController()
@property (strong, nonatomic) Deck *deck;
@end

@implementation MatchCardGameViewController

- (Deck *)deck {
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    return _deck;
}

//- (void) updateGame:(NSArray *)cardButtons {
//    for (UIButton *cardButton in cardButtons) {
//        Card *card = [self.game cardAtIndex:[cardButtons indexOfObject:cardButton]];
//        UIImage *cardBackImage = [UIImage imageNamed:@"cardback.jpg"];
//        if (!card.faceUp && !card.unplayable) {
//            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
//            //            [cardButton setImageEdgeInsets:UIEdgeInsetsMake(3, 0, 3, 0)];
//        }
//        else {
//            [cardButton setImage:nil forState:UIControlStateNormal];
//            [cardButton setTitle:[card contents] forState:UIControlStateSelected];
//            [cardButton setTitle:[card contents] forState:UIControlStateSelected|UIControlStateDisabled];
//        }
//        cardButton.selected = card.isFaceUP;
//        cardButton.enabled = !card.isUnplayable;
//        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
//    }
//}

- (NSUInteger) startingCardCount {
    return 22;
}

- (NSString *) reusableCellId {
    return @"PlayingCard";
}

- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card {
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *) cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *) card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.faceUp;
            playingCardView.alpha = playingCard.unplayable ? 0.3 : 1.0;
        }
    }
}

@end
