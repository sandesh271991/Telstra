//
//  TelstraTests.m
//  TelstraTests
//
//  Created by LION-2 on 5/31/17.
//  Copyright © 2017 Infosys. All rights reserved.
//






#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "APIDataFetcher.h"

@interface TelstraTests : XCTestCase

@property (nonatomic, strong) ViewController *vc;

@end

@implementation TelstraTests

- (void)setUp
{
    [super setUp];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.vc = [storyboard instantiateViewControllerWithIdentifier:@"tableViewStroyID"];
    [self.vc performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    self.vc = nil;
    [super tearDown];
}

#pragma mark - View loading tests
-(void)testThatViewLoads
{
    XCTAssertNotNil(self.vc.view, @"View not initiated properly");
}



#pragma mark - UITableView tests
- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}


- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}



- (void)testTableViewNumberOfRowsInSection
{
    
    NSInteger expectedRows = self.vc.content.count;
    
    XCTAssertTrue([self.vc.tableView numberOfRowsInSection:0] ==expectedRows, @"Table has %ld rows but it should have %ld", (long)[self.vc.tableView numberOfRowsInSection:0],(long)expectedRows);
    
}



@end