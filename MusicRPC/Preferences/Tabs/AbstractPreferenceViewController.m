//
//  AbstractPreferenceViewController.m
//  Mac-Menu-Bar-App-Template
//
//  Created by Alexandra Aurora Göttlicher
//

#import "AbstractPreferenceViewController.h"
#import "../../Environment.h"

@implementation AbstractPreferenceViewController
- (instancetype)init {
    self = [super init];

    if (self) {
        _preferenceManager = [[Environment sharedInstance] preferenceManager];
    }

    return self;
}
@end
