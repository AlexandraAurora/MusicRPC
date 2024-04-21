//
//  CheckboxCell.m
//  Mac-Menu-Bar-App-Template
//
//  Created by Alexandra Aurora Göttlicher
//

#import "AbstractCell.h"

@interface CheckboxCell : AbstractCell
@property(nonatomic)NSButton* checkbox;
- (void)setTarget:(id)target;
- (void)setAction:(SEL)action;
- (void)setCheckboxTitle:(NSString *)title;
- (void)setOn:(BOOL)on;
- (BOOL)getIsOn;
@end
