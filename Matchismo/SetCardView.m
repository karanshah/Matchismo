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
#define MARGIN_WIDTH 0.2
#define STROKE_WIDTH 1.0
#define SYMBOL_HEIGHT 0.2
#define SYMBOL_OFFSET 0.05

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width * CORNER_RADIUS];
    
    [roundedRect addClip];
    
    UIColor *cellBackgroundColor = self.faceUp ? [UIColor colorWithWhite:0.8 alpha:0.8] : [UIColor whiteColor];
    
    [cellBackgroundColor setFill];
    UIRectFill(self.bounds);
    
    [[self getUIColorForSetCard:self.color] setFill];
    [[self getUIColorForSetCard:self.color] setStroke];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGRect setRect = CGRectInset(self.bounds, self.bounds.size.width * MARGIN_WIDTH,
                                 self.bounds.size.height * SYMBOL_HEIGHT * 2);
    
    UIBezierPath *symbolPath = [self drawSetSymbol:setRect];
    [symbolPath setLineWidth:STROKE_WIDTH];
    
    CGFloat heightOffset = SYMBOL_HEIGHT + SYMBOL_OFFSET;
    CGFloat offsetSymbol = 0.0;
    
    if (self.number == 2) {
        offsetSymbol = self.bounds.size.height * heightOffset / 2;
    }
    else if (self.number == 3) {
        offsetSymbol = self.bounds.size.height * heightOffset;
    }

    CGContextTranslateCTM(context, 0.0, -offsetSymbol);
    
    for (int i = 0; i < self.number; i++) {
        if ([self.shading isEqualToString:@"open"]) {
            [symbolPath stroke];
        }
        else if ([self.shading isEqualToString:@"solid"]) {
            [symbolPath fill];
        }
        else if ([self.shading isEqualToString:@"stripped"]) {
            [symbolPath stroke];
            CGContextSaveGState(context);
            [symbolPath addClip];
            [self addStripes:symbolPath.bounds];
            CGContextRestoreGState(context);
        }
        CGContextTranslateCTM(context, 0.0, self.bounds.size.height * heightOffset);
    }
    
    CGContextRestoreGState(context);

}

- (UIBezierPath *)drawSetSymbol:(CGRect) rect {
    UIBezierPath *symbol = nil;
    if ([self.symbol isEqualToString:@"diamond"]) {
        symbol = [self drawDiamondSetSymbol:rect];
    }
    else if ([self.symbol isEqualToString:@"squiggle"]) {
        symbol = [self drawSquiggleSymbol:rect];
    }
    else if ([self.symbol isEqualToString:@"oval"]) {
        symbol = [self drawOvalSetSymbol:rect];
    }
    return symbol;
}

- (UIBezierPath *)drawSquiggleSymbol:(CGRect) rect {
    UIBezierPath *squiggleSymbol = [UIBezierPath bezierPath];
    
    [squiggleSymbol moveToPoint:CGPointMake(rect.origin.x , rect.origin.y + rect.size.height * 0.5)];
    [squiggleSymbol addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.25, rect.origin.y + rect.size.height * 0.125)
                     controlPoint1:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.25)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.125, rect.origin.y + rect.size.height * 0.125)];
    
    [squiggleSymbol addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.625, rect.origin.y + rect.size.height * 0.25)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width * 0.365, rect.origin.y + rect.size.height * 0.125)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height * 0.25)];
    
    [squiggleSymbol addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.875, rect.origin.y)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width * 0.75, rect.origin.y + rect.size.height * 0.25)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.75, rect.origin.y)];
    
    [squiggleSymbol addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height * 0.5)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height * 0.25)];
    
    [squiggleSymbol addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.75, rect.origin.y + rect.size.height * 0.875)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height * 0.75)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.875, rect.origin.y + rect.size.height * 0.875)];
    
    [squiggleSymbol addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.365, rect.origin.y + rect.size.height * 0.75)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width * 0.625, rect.origin.y + rect.size.height * 0.875)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.5, rect.origin.y + rect.size.height * 0.75)];
    
    [squiggleSymbol addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.125, rect.origin.y + rect.size.height)
                     controlPoint1:CGPointMake(rect.origin.x + rect.size.width * 0.25, rect.origin.y + rect.size.height * 0.75)
                     controlPoint2:CGPointMake(rect.origin.x + rect.size.width * 0.25, rect.origin.y + rect.size.height)];
    
    [squiggleSymbol addCurveToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.5)
                     controlPoint1:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height)
                     controlPoint2:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.75)];
    
    [squiggleSymbol closePath];
    
    
    return squiggleSymbol;
}

- (UIBezierPath *)drawDiamondSetSymbol:(CGRect) rect {
    UIBezierPath *diamondSymbol = [UIBezierPath bezierPath];
    [diamondSymbol moveToPoint:CGPointMake(rect.origin.x,
                                           rect.origin.y + rect.size.height * 0.5)];
    [diamondSymbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.5,
                                              rect.origin.y)];
    [diamondSymbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width,
                                              rect.origin.y + rect.size.height * 0.5)];
    [diamondSymbol addLineToPoint:CGPointMake(rect.origin.x + rect.size.width * 0.5,
                                              rect.origin.y + rect.size.height)];
    [diamondSymbol closePath];
    return diamondSymbol;
}

- (UIBezierPath *)drawOvalSetSymbol:(CGRect) rect {
    UIBezierPath *ovalSymbol = [UIBezierPath bezierPathWithOvalInRect:rect];
    return ovalSymbol;
}

- (UIColor *)getUIColorForSetCard:(NSString *) setCardColor {
    UIColor *uiColor = [UIColor blackColor];
    if ([setCardColor isEqualToString:@"red"]) {
        uiColor = [UIColor redColor];
    } else if ([setCardColor isEqualToString:@"blue"]) {
        uiColor = [UIColor blueColor];
    } else if ([setCardColor isEqualToString:@"green"]) {
        uiColor = [UIColor greenColor];
    }
    return uiColor;
}

#define STRIPE_LINE_GAP 0.1

- (void)addStripes:(CGRect) rect {
    UIBezierPath *stripes = [UIBezierPath bezierPath];
    CGFloat lineGap = rect.size.width * STRIPE_LINE_GAP;
    for (CGFloat i = 0; i < rect.size.width; i += lineGap) {
        [stripes moveToPoint:CGPointMake(rect.origin.x + i, rect.origin.y)];
        [stripes addLineToPoint:CGPointMake(rect.origin.x + i, rect.origin.y + rect.size.height)];
    }
    [stripes stroke];
}

//Should be 0, 1, 2 or 3
- (void)setNumber:(NSInteger)number {
    if (number >= 0 && number <= 3) {
        _number = number;
        [self setNeedsDisplay];
    }
}

//Should be @"diamond", @"oval" or @"squiggle"
- (void)setSymbol:(NSString *)symbol {
    _symbol = nil;
    if ([[SetCard validSymbols] containsObject:symbol]) {
        _symbol = symbol;
    }
    [self setNeedsDisplay];
}

//Should be @"open", @"stripped" or @"solid"
- (void)setShading:(NSString *)shading {
    _shading = nil;
    if ([[SetCard validShadings] containsObject:shading]) {
        _shading = shading;
    }
    [self setNeedsDisplay];
}

//Should be @"red", @"blue" or @"green"
- (void)setColor:(NSString *)color {
    _color = nil;
    if ([[SetCard validColors] containsObject:color]) {
        _color = color;
    }
    [self setNeedsDisplay];
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
