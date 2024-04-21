//
//  DescriptionCell.h
//  Mac-Menu-Bar-App-Template
//
//  Created by Alexandra Aurora Göttlicher
//

#import "AbstractCell.h"

@interface DescriptionCell : AbstractCell
@property(nonatomic)NSTextField* descriptionLabel;
- (void)setDescription:(NSString *)description;
@end
