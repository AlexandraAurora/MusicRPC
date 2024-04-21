//
//  DropdownCell.h
//  Mac-Menu-Bar-App-Template
//
//  Created by Alexandra Aurora Göttlicher
//

#import "AbstractCell.h"

@interface DropdownCell : AbstractCell
@property(nonatomic)NSPopUpButton* dropdown;
- (void)setTarget:(id)target;
- (void)setAction:(SEL)action;
- (void)setOptions:(NSArray *)options;
- (void)setTags:(NSArray *)tags;
- (NSInteger)getSelectedTag;
- (void)selectItemWithTag:(NSInteger)tag;
@end
