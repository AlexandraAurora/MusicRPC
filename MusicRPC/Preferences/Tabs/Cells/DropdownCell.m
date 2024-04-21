//
//  DropdownCell.m
//  Mac-Menu-Bar-App-Template
//
//  Created by Alexandra Aurora Göttlicher
//

#import "DropdownCell.h"

@implementation DropdownCell
- (instancetype)init {
    self = [super init];

    if (self) {
        [self setDropdown:[[NSPopUpButton alloc] init]];
        [self addSubview:[self dropdown]];

        [[self dropdown] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self dropdown] topAnchor] constraintEqualToAnchor:[self topAnchor]],
            [[[self dropdown] leadingAnchor] constraintEqualToAnchor:[[self label] trailingAnchor] constant:8],
            [[[self dropdown] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];
    }

    return self;
}

- (void)setTarget:(id)target {
    [[self dropdown] setTarget:target];
}

- (void)setAction:(SEL)action {
    [[self dropdown] setAction:action];
}

- (void)setOptions:(NSArray *)options {
    [[self dropdown] addItemsWithTitles:options];
}

- (void)setTags:(NSArray *)tags {
    for (NSUInteger i = 0; i < [tags count]; i++) {
        [[[self dropdown] itemAtIndex:i] setTag:[tags[i] integerValue]];
    }
}

- (NSInteger)getSelectedTag {
    return [[[self dropdown] selectedItem] tag];
}

- (void)selectItemWithTag:(NSInteger)tag {
    [[self dropdown] selectItemWithTag:tag];
}
@end
