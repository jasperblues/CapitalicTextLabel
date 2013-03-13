////////////////////////////////////////////////////////////////////////////////
//
//  MOD PRODUCTIONS
//  Copyright 2012 Mod Productions
//  All Rights Reserved.
//
//  NOTICE: Mod Productions permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import "CapitalicTextLabel.h"

@implementation CapitalicTextLabel

const static CGFloat fontSizeMultiple = 1.4;

/* ========================================================== Interface Methods ========================================================= */
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetCharacterSpacing(context, 1);
    CGContextSetFillColorWithColor(context, [self.textColor CGColor]);
    CGAffineTransform myTextTransform = CGAffineTransformScale(CGAffineTransformIdentity, 1.f, -1.f);
    CGContextSetTextMatrix(context, myTextTransform);

    CGPoint drawPoint = [self startingDrawPoint];
    CGFloat firstLetterSize = self.font.pointSize * fontSizeMultiple;

    NSArray* words = [self.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    for (NSString* word in words)
    {
        NSString* letter = [[word substringToIndex:1] uppercaseString];
        CGContextSelectFont(context, [self.font.fontName cStringUsingEncoding:NSASCIIStringEncoding], firstLetterSize, kCGEncodingMacRoman);
        CGContextShowTextAtPoint(context, drawPoint.x, drawPoint.y, [letter cStringUsingEncoding:NSASCIIStringEncoding], [letter length]);
        drawPoint.x = CGContextGetTextPosition(context).x;

        NSString* restOfWord = [[[word substringFromIndex:1] uppercaseString] stringByAppendingString:@" "];
        CGContextSelectFont(context, [self.font.fontName cStringUsingEncoding:NSASCIIStringEncoding], self.font.pointSize,
                kCGEncodingMacRoman);
        CGContextShowTextAtPoint(context, drawPoint.x, drawPoint.y, [restOfWord cStringUsingEncoding:NSASCIIStringEncoding],
                [restOfWord length]);
        drawPoint.x = CGContextGetTextPosition(context).x;
    }
}

- (void)sizeToFit
{
    CGFloat totalWidth = 0;
    CGFloat height = 0;
    NSArray* words = [self.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    for (NSString* word in words)
    {
        NSString* letter = [[word substringToIndex:1] uppercaseString];
        UIFont* font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize * fontSizeMultiple];
        CGSize size = [letter sizeWithFont:font];
        totalWidth += size.width;
        if (height == 0)
        {
            height = size.height;
        }
        NSString* restOfWord = [[[word substringFromIndex:1] uppercaseString] stringByAppendingString:@" "];
        totalWidth += [restOfWord sizeWithFont:self.font].width;
    }
    self.width = totalWidth * 1.08;
    self.height = height;
}


/* ============================================================ Private Methods ========================================================= */
- (CGPoint)startingDrawPoint
{
    CGPoint startingPoint;
    if (self.textAlignment == NSTextAlignmentLeft)
    {
        startingPoint = (CGPoint) {0, (self.font.pointSize + (self.frame.size.height - self.font.pointSize) / 2) - 2};
    } else
    {
        [NSException raise:NSInvalidArgumentException format:@"Alignments besides NSTextAlignmentLeft not implemented yet."];
    }
    return startingPoint;
}

@end