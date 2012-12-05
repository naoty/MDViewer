//
//  NSString+Filetype.m
//  MDViewer
//
//  Created by naoty on 2012/12/05.
//  Copyright (c) 2012年 naoty. All rights reserved.
//

#import "NSString+Filetype.h"

@implementation NSString (Filetype)

- (BOOL)isMarkdown
{
    return [@[@"md", @"mkd", @"markdown"] containsObject:[self pathExtension]];
}

- (BOOL)isCSS
{
    return [[self pathExtension] isEqualToString:@"css"];
}

@end
