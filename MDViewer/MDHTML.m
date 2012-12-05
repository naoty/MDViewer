//
//  MDHTML.m
//  MDViewer
//
//  Created by naoty on 2012/12/05.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import "MDHTML.h"

@implementation MDHTML

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)stringify
{
    if (self.style == nil) {
        return self.body;
    } else {
        return [NSString stringWithFormat:@"<style>%@</style>\n%@", self.style, self.body];
    }
}

@end
