//
//  MDHTML.h
//  MDViewer
//
//  Created by naoty on 2012/12/05.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDHTML : NSObject

@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *style;

- (NSString *)stringify;

@end
