//
//  AbstractCell.m
//  Mac-Menu-Bar-App-Template
//
//  Created by Alexandra Aurora Göttlicher
//

#import "AbstractCell.h"

@implementation AbstractCell
- (instancetype)init {
    self = [super init];

    if (self) {
        [self setLabel:[[NSTextField alloc] init]];
        [[self label] setFont:[NSFont systemFontOfSize:13]];
        [[self label] setAlignment:NSTextAlignmentRight];
        [[self label] setBezeled:NO];
        [[self label] setDrawsBackground:NO];
        [[self label] setEditable:NO];
        [[self label] setSelectable:NO];
        [self addSubview:[self label]];

        [[self label] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self label] widthAnchor] constraintEqualToConstant:110],
            [[[self label] topAnchor] constraintEqualToAnchor:[self topAnchor]],
            [[[self label] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self label] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];
    }

    return self;
}

- (void)setTitle:(NSString *)title {
    [[self label] setStringValue:title];
}
@end
