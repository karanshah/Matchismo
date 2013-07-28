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
@property (strong, nonatomic) NSMutableAttributedString *attributedResult;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@end

@implementation CardGameViewController

//Subclasses should implement this
- (Deck *)deck {
    return nil;
}

- (void) updateGame:(NSArray *)cardButtons {

}

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count
                                                          usingDeck:[self deck]];
    return _game;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

- (void) updateUI {
    [self updateGame:[self cardButtons]];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultLabel.attributedText = self.attributedResult;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flips updated to %d", self.flipCount);
}

- (IBAction)dealNewGame:(UIButton *)sender {
    self.game = nil;
    self.deck = nil;
    self.attributedResult = nil;
    self.flipCount = 0;
    self.gameType = 0;
    self.gameTypeSegment.userInteractionEnabled = YES;
    self.gameTypeSegment.alpha = 1.0;
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender {
//    NSLog(@"Slected Segment = %d", self.gameTypeSegment.selectedSegmentIndex);
    if (self.gameType == 0) {
        self.gameType = self.gameTypeSegment.selectedSegmentIndex + 2;
        self.game.gameType = self.gameType;
        self.gameTypeSegment.userInteractionEnabled = NO;
        self.gameTypeSegment.alpha = 0.5;
    }
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    NSArray *resultArray = [self.game flipCardAtIndex:cardIndex];
    [self getResultText:resultArray];
    sender.selected ? self.flipCount : self.flipCount++;
    [self updateUI];
}

- (void) getResultText:(NSArray *) resultArray {
    NSMutableAttributedString *resultAttributedString = [[NSMutableAttributedString alloc] init];
    for (id resultObject in resultArray) {
        if ([resultObject isKindOfClass:[NSArray class]]) {
            NSArray *resultObjectArray = (NSArray *) resultObject;
            for (int i = 0; i < resultObjectArray.count; i++) {
                
                [resultAttributedString appendAttributedString:[self getAttributesForCardAsId:resultObjectArray[i]]];
                if (i < resultObjectArray.count-1) {
                    [resultAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@", "]];
                }
            }
        }
        else if ([resultObject isKindOfClass:[Card class]]) {
            [resultAttributedString appendAttributedString:[self getAttributesForCardAsId:resultObject]];
        }
        else if ([resultObject isKindOfClass:[NSString class]]) {
            NSString *objectString = (NSString *) resultObject;
            [resultAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:objectString]];
        }
        [resultAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
    }
    self.attributedResult = resultAttributedString;
}

- (NSAttributedString *) getAttributesForCardAsId:(id) resultObject {
    NSAttributedString *cardAttributedTitle = nil;
    if ([resultObject isKindOfClass:[Card class]]) {
        Card *card = (Card *) resultObject;
        cardAttributedTitle = [[NSAttributedString alloc] initWithString:[card contents] attributes:[self getCardAttributes:card]];
    }
    return cardAttributedTitle;
}

//-(void) getResultText: (NSUInteger)index {
//    NSMutableAttributedString *resultAttributedString = [[NSMutableAttributedString alloc] initWithString:@"Flipped up "];
//    Card *card = [self.game cardAtIndex:index];
//    NSAttributedString *cardAttributedTitle = [[NSAttributedString alloc] initWithString:[card contents] attributes:[self getCardAttributes:card]];
//    if ([self.game.result isEqualToString:@"Matched"]) {
//        
//    }
//    else {
//        [resultAttributedString appendAttributedString:cardAttributedTitle];
//    }
//    self.attributedResult = resultAttributedString;
//}

- (NSDictionary *) getCardAttributes:(Card *)card {
    return [[NSDictionary alloc] init];
}

@end
