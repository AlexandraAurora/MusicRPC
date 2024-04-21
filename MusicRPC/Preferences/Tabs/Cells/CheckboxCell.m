//
//  CheckboxCell.m
//  Mac-Menu-Bar-App-Template
//
//  Created by Alexandra Aurora Göttlicher
//

#import "CheckboxCell.h"

@implementation CheckboxCell
- (instancetype)init {
    self = [super init];

    if (self) {
        [self setCheckbox:[[NSButton alloc] init]];
        [[self checkbox] setButtonType:NSButtonTypeSwitch];
        [[self checkbox] setFont:[NSFont systemFontOfSize:13]];
        [self addSubview:[self checkbox]];

        [[self checkbox] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self checkbox] topAnchor] constraintEqualToAnchor:[self topAnchor]],
            [[[self checkbox] leadingAnchor] constraintEqualToAnchor:[[self label] trailingAnchor] constant:8],
            [[[self checkbox] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
            [[[self checkbox] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];
    }

    return self;
}

- (void)setTarget:(id)target {
    [[self checkbox] setTarget:target];
}

- (void)setAction:(SEL)action {
    [[self checkbox] setAction:action];
}

- (void)setCheckboxTitle:(NSString *)title {
    [[self checkbox] setTitle:title];
}

- (void)setOn:(BOOL)on {
    [[self checkbox] setState:on ? NSControlStateValueOn : NSControlStateValueOff];
}

- (BOOL)getIsOn {
    return [[self checkbox] state] == NSControlStateValueOn;
}
@end
