//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Karan Shah on 7/17/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import "CardGameViewController.h"
#import "Deck.h"
#import "PlayingCardDeck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@end

@implementation CardGameViewController

- (Deck *)deck {
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    return _deck;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    for (UIButton *cardButton in cardButtons) {
        Card *card = [self.deck drawRandomCard];
        [cardButton setTitle:[card contents] forState:UIControlStateSelected];
    }
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flips updated to %d", self.flipCount);
}

- (IBAction)flipCard:(UIButton *)sender {
 
    sender.selected = !sender.selected;
    self.flipCount++;
}

@end
