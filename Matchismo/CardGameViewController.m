//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Karan Shah on 7/17/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//
//  Icons by Glyphish

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutlet UISegmentedControl *gameTypeSegment;

@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) NSMutableAttributedString *attributedResult;
//@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (strong, nonatomic) IBOutletCollection(UIView) NSMutableArray *selectedCardViews;
@property (strong, nonatomic) IBOutlet UIButton *moreCardsButton;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) NSArray *selectedCards;
@end

@implementation CardGameViewController

//Subclasses should implement this
- (Deck *)deck {
    return nil;
}

//- (void) updateGame:(NSArray *)cardButtons {
//
//}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.game.cardCount;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reusableCellId forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}

- (void) updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card {
    //abstract
}

- (void)updateSelectedCardView:(UIView *)view usingCard:(Card *)card asMatchedCard:(BOOL)asMatchedCard {
    //abstract
}

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                  usingDeck:[self deck]
                                               withGameType:[self gameType]];
    }
    return _game;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

- (void) updateUI {
//    [self updateGame:[self cardButtons]];
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
    }
    if (self.selectedCardViews.count) {
        for (int index = 0; index < self.selectedCardViews.count; index++) {
            [self updateSelectedCardView:self.selectedCardViews[index] usingCard:(index < self.selectedCards.count) ? self.selectedCards[index] : nil asMatchedCard:self.selectedCards.count == self.selectedCardViews.count];
        }
    }
    [self updateMoreCardsButton];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    self.resultLabel.attributedText = self.attributedResult;
}

- (void)updateMoreCardsButton {
    if (self.deck.hasMoreCards) {
        self.moreCardsButton.enabled = YES;
        self.moreCardsButton.alpha = 1.0;
    }
    else {
        self.moreCardsButton.enabled = NO;
        self.moreCardsButton.alpha = 0.4;
    }
}

- (void)setFlipCount:(int)flipCount {
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
    NSLog(@"flips updated to %d", self.flipCount);
}

- (IBAction)dealNewGame:(UIButton *)sender {
    self.game = nil;
    self.deck = nil;
    self.selectedCards = nil;
    self.attributedResult = nil;
    self.flipCount = 0;
    self.gameType = 0;
    self.gameTypeSegment.userInteractionEnabled = YES;
    self.gameTypeSegment.alpha = 1.0;
    [self updateUI];
    [self.cardCollectionView reloadData];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture {
//    NSLog(@"Slected Segment = %d", self.gameTypeSegment.selectedSegmentIndex);
    if (self.gameType == 0) {
        self.gameType = self.gameTypeSegment.selectedSegmentIndex + 2;
        self.game.gameType = self.gameType;
        self.gameTypeSegment.userInteractionEnabled = NO;
        self.gameTypeSegment.alpha = 0.5;
    }
    CGPoint tapLoction = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLoction];
    if (indexPath) {
        NSArray *resultArray = [self.game flipCardAtIndex:indexPath.item];
        self.selectedCards = [self selectedCardsWithCard:[self.game cardAtIndex:indexPath.item]];
        [self getResult:resultArray forSelectedCard:self.selectedCardViews];
//        indexPath.item.selected ? self.flipCount : self.flipCount++;
        [self updateUI];
    }
    
}

- (NSArray *)selectedCardsWithCard:(Card *)card {
    NSMutableArray *selectedCardsToKeep = (self.selectedCards.count < self.selectedCardViews.count) ? [NSMutableArray arrayWithArray:self.selectedCards] : [[NSMutableArray alloc] init];
    
    if (card) {
        if (self.selectedCards.count >= self.selectedCardViews.count) {
            for (int index = 0; index < self.selectedCards.count; index++) {
                Card *selectedCard = self.selectedCards[index];
                if (selectedCard.faceUp && !selectedCard.isUnplayable) {
                    [selectedCardsToKeep addObject:selectedCard];
                }
            }
        }
        
        [selectedCardsToKeep removeObject:card];
        
        if (card.faceUp) {
            [selectedCardsToKeep addObject:card];
        }
    }
    
    return selectedCardsToKeep;
}

- (void) getResult:(NSArray *) resultArray forSelectedCard:(NSMutableArray *) cardViews {
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

- (NSDictionary *) getCardAttributes:(Card *)card {
    return [[NSDictionary alloc] init];
}

- (NSInteger) gameType {
    if (!_gameType) {
        _gameType = 2;
    }
    return _gameType;
}

- (void) removeCell:(UICollectionViewCell *)cell usingCard:(Card *) card {
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
    if (indexPath) {
        [self.game removeCardAtIndex:indexPath.item];
        [self.cardCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
}

- (IBAction)addMoreCards:(UIButton *)sender {
    NSUInteger startIndex = self.game.cardCount;
    [self.game addCardsWithCount:startIndex + 3 usingDeck:self.deck intialIndex:startIndex];
    [self.cardCollectionView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:startIndex+2 inSection:0];
    [self.cardCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
    
    [self updateUI];
}

- (NSArray *)selectedCards {
    if (!_selectedCards) {
        _selectedCards = [[NSArray alloc] init];
    }
    
    return _selectedCards;
}

@end
