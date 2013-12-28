//
// Created by sorenu on 28/12/13.
// Copyright (c) 2013 Shape A/S. All rights reserved.
//

@class RACSignal;


@interface ViewModel : NSObject

@property (strong, nonatomic) NSString *searchResult;

- (void)performSearchWithQuery:(NSString *)query;

@end