//
//  SeparatorCell.m
//  Mac-Menu-Bar-App-Template
//
//  Created by Alexandra Aurora Göttlicher
//

#import "SeparatorCell.h"

@implementation SeparatorCell
- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];

    if (self) {
        [self setSeparator:[[NSBox alloc] init]];
        [[self separator] setBoxType:NSBoxSeparator];
        [self addSubview:[self separator]];

        [[self separator] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self separator] topAnchor] constraintEqualToAnchor:[self topAnchor]],
            [[[self separator] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self separator] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
            [[[self separator] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];
    }

    return self;
}
@end
