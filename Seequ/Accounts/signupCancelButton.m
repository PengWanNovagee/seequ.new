//
//  signupCancelButton.m
//  Seequ
//
//  Created by peng wan on 15-2-8.
//  Copyright (c) 2015 Seequ. All rights reserved.
//

#import "signupCancelButton.h"
#import "RingStyleKit.h"

@interface signupCancelButton ()
@property (assign, nonatomic) BOOL isPressed;
@end

@implementation signupCancelButton

- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.isPressed) {
        [RingStyleKit drawRegistration_footer_cancel_buttonWithPressed:YES];
    } else
        [RingStyleKit drawRegistration_footer_cancel_buttonWithPressed:NO];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isPressed = YES;
    [self setNeedsDisplay];
    [super touchesBegan:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isPressed = NO;
    [self setNeedsDisplay];
    [super touchesEnded:touches withEvent:event];
}

@end
