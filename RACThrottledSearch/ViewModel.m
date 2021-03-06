//
// Created by sorenu on 28/12/13.
// Copyright (c) 2013 Shape A/S. All rights reserved.
//

#import "ViewModel.h"

@interface ViewModel ()
@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;
@property (strong, nonatomic) RACDisposable *currentSearchDisposable;
@end

@implementation ViewModel {

}

- (id)init {
    self = [super init];
    if (self) {
        self.requestOperationManager = [AFHTTPRequestOperationManager manager];
    }

    return self;
}

- (void)performSearchWithQuery:(NSString *)query {
    [self.currentSearchDisposable dispose];

    RACSignal *searchSignal = [self searchSignalWithQuery:query];

    @weakify(self)
    self.currentSearchDisposable = [searchSignal subscribeNext:^(NSDictionary *result) {
        @strongify(self)
        NSLog(@"result = %@", result);
        self.searchResult = result ? [NSString stringWithFormat:@"%@", result] : @"";
    } error:^(NSError *error) {
        self.searchResult = @"Search failed";
    }];
}

- (RACSignal *)searchSignalWithQuery:(NSString *)query {
    NSString *urlString = [NSString stringWithFormat:@"http://bestwebserviceintheworld.herokuapp.com/?q=%@", query];
    return [[self.requestOperationManager rac_GET:urlString parameters:nil] map:^(RACTuple *tuple) {
        RACTupleUnpack(AFHTTPRequestOperation *operation, NSDictionary *response) = tuple;
        return response;
    }];
}

@end