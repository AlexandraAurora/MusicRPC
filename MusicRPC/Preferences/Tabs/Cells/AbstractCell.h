//
//  AbstractCell.h
//  Mac-Menu-Bar-App-Template
//
//  Created by Alexandra Aurora Göttlicher
//

#import <AppKit/AppKit.h>

@interface AbstractCell : NSView
@property(nonatomic)NSTextField* label;
- (void)setTitle:(NSString *)title;
@end
