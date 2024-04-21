//
//  DescriptionCell.m
//  Mac-Menu-Bar-App-Template
//
//  Created by Alexandra Aurora Göttlicher
//

#import "DescriptionCell.h"

@implementation DescriptionCell
- (instancetype)init {
    self = [super init];

    if (self) {
        [self setDescriptionLabel:[[NSTextField alloc] init]];
        [[self descriptionLabel] setFont:[NSFont systemFontOfSize:11]];
        [[self descriptionLabel] setTextColor:[NSColor systemGrayColor]];
        [[self descriptionLabel] setBezeled:NO];
        [[self descriptionLabel] setDrawsBackground:NO];
        [[self descriptionLabel] setEditable:NO];
        [[self descriptionLabel] setSelectable:NO];
        [self addSubview:[self descriptionLabel]];

        [[self descriptionLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self descriptionLabel] topAnchor] constraintEqualToAnchor:[self topAnchor]],
            [[[self descriptionLabel] leadingAnchor] constraintEqualToAnchor:[[self label] trailingAnchor] constant:8],
            [[[self descriptionLabel] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
            [[[self descriptionLabel] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];
    }

    return self;
}

- (void)setDescription:(NSString *)description {
    [[self descriptionLabel] setStringValue:description];
}
@end
