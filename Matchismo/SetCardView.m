//
//  SetCardView.m
//  Matchismo
//
//  Created by Karan Shah on 7/30/13.
//  Copyright (c) 2013 Karan Shah. All rights reserved.
//

#import "SetCardView.h"
#import "SetCard.h"

@implementation SetCardView

#define CORNER_RADIUS 0.1

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width * CORNER_RADIUS];
    
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];

}

//Should be 1, 2 or 3
- (void)setNumber:(NSInteger)number {
    if (number >= 1 && number <= 3) {
        _number = number;
        [self setNeedsDisplay];
    }
}

//Should be @"diamond", @"oval" or @"squiggle"
- (void)setSymbol:(NSString *)symbol {
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
        [self setNeedsDisplay];
    }
}

//Should be @"open", @"stripped" or @"solid"
- (void)setShading:(NSString *)shading {
    if ([[SetCard validShadings] containsObject:shading]) {
        _shading = shading;
        [self setNeedsDisplay];
    }
}

//Should be @"red", @"blue" or @"green"
- (void)setColor:(NSString *)color {
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
        [self setNeedsDisplay];
    }
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (void)setup
{
    // do initialization here
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

@end
