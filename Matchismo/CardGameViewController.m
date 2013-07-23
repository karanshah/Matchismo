//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Karan Shah on 7/17/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutlet UISegmentedControl *gameTypeSegment;
@property (nonatomic) NSInteger gameType;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation CardGameViewController

- (Deck *)deck {
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    return _deck;
}

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[[PlayingCardDeck alloc] init]];
    return _game;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

- (void) updateUI {
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        UIImage *cardBackImage = [UIImage imageNamed:@"cardback.jpg"];
        if (!card.faceUp && !card.unplayable) {
            [cardButton setImage:cardBackImage forState:UIControlStateNormal];
//            [cardButton setImageEdgeInsets:UIEdgeInsetsMake(3, 0, 3, 0)];
        }
        else {
            [cardButton setImage:nil forState:UIControlStateNormal];
            [cardButton setTitle:[card contents] forState:UIControlStateSelected];
            [cardButton setTitle:[card contents] forState:UIControlStateSelected|UIControlStateDisabled];
        }    
        cardButton.selected = card.isFaceUP;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultLabel.text = self.game.result;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
//    NSLog(@"flips updated to %d", self.flipCount);
}

- (IBAction)dealNewGame:(UIButton *)sender {
    self.game = nil;
    self.flipCount = 0;
    self.gameType = 0;
    self.gameTypeSegment.userInteractionEnabled = YES;
    self.gameTypeSegment.alpha = 1.0;
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender {
    NSLog(@"Slected Segment = %d", self.gameTypeSegment.selectedSegmentIndex);
    if (self.gameType == 0) {
        self.gameType = self.gameTypeSegment.selectedSegmentIndex + 2;
        self.game.gameType = self.gameType;
        self.gameTypeSegment.userInteractionEnabled = NO;
        self.gameTypeSegment.alpha = 0.5;
    }
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

@end
