//
// Created by sorenu on 28/12/13.
// Copyright (c) 2013 Shape A/S. All rights reserved.
//

#import "ViewController.h"
#import "ViewModel.h"

static const NSInteger kMinimumQueryLength = 2;

@interface ViewController ()
@property (strong, nonatomic) UITextField *searchInputTextField;
@property (strong, nonatomic) UITextView *searchResultTextView;
@end

@implementation ViewController {

}

- (id)init {
    self = [super init];
    if (self) {
        self.viewModel = [ViewModel new];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
    [self setupRACBindings];
}


#pragma mark - View stuff

- (void)setupViews {
    self.view.backgroundColor = [UIColor colorWithRed:(192/255.f) green:(154/255.f) blue:(50/255.f) alpha:1.0];

    [self.view addSubview:self.searchInputTextField];
    [self.view addSubview:self.searchResultTextView];

    self.searchInputTextField.frame = CGRectMake(10, 40, 300, 50);
    self.searchResultTextView.frame = CGRectMake(10, CGRectGetMaxY(self.searchInputTextField.frame) + 10, 300, 200);
}


#pragma mark - Reactive Cocoa stuff

- (void)setupRACBindings {
    @weakify(self)
    [[[self.searchInputTextField.rac_textSignal filter:^BOOL(NSString *text) {
        return text.length >= kMinimumQueryLength;
    }] throttle:0.5] subscribeNext:^(NSString *query) {
        NSLog(@"query = %@", query);
        @strongify(self)
        [self.viewModel performSearchWithQuery:query];
    }];

    RAC(self.searchResultTextView, text) = RACObserve(self.viewModel, searchResult);
}


#pragma mark - Lazy loading views

- (UITextField *)searchInputTextField {
    if (!_searchInputTextField) {
        _searchInputTextField = [UITextField new];
        _searchInputTextField.backgroundColor = [UIColor whiteColor];
        _searchInputTextField.placeholder = NSLocalizedString(@"Enter query", nil);
        _searchInputTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    return _searchInputTextField;
}

- (UITextView *)searchResultTextView {
    if (!_searchResultTextView) {
        _searchResultTextView = [UITextView new];
        _searchResultTextView.backgroundColor = [UIColor whiteColor];
        _searchResultTextView.editable = NO;
    }
    return _searchResultTextView;
}


@end