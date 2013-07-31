//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Karan Shah on 7/30/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end
