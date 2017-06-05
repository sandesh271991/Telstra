//
//  TelstraTests.m
//  TelstraTests
//
//  Created by LION-2 on 5/31/17.
//  Copyright © 2017 Infosys. All rights reserved.
//






#import <XCTest/XCTest.h>
//#import "ViewController_Private.h"
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

- (void)testParentViewHasTableViewSubview
{
    NSArray *subviews = self.vc.view.subviews;
    XCTAssertTrue([subviews containsObject:self.vc.tableView], @"View does not have a table subview");
}

-(void)testThatTableViewLoads
{
    XCTAssertNotNil(self.vc.tableView, @"TableView not initiated");
}

#pragma mark - UITableView tests
- (void)testThatViewConformsToUITableViewDataSource
{
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDataSource) ], @"View does not conform to UITableView datasource protocol");
}

- (void)testThatTableViewHasDataSource
{
    XCTAssertNotNil(self.vc.tableView.dataSource, @"Table datasource cannot be nil");
}

- (void)testThatViewConformsToUITableViewDelegate
{
    XCTAssertTrue([self.vc conformsToProtocol:@protocol(UITableViewDelegate) ], @"View does not conform to UITableView delegate protocol");
}

- (void)testTableViewIsConnectedToDelegate
{
    XCTAssertNotNil(self.vc.tableView.delegate, @"Table delegate cannot be nil");
}

- (void)testTableViewNumberOfRowsInSection
{

    
      NSInteger expectedRows = self.vc.content.count;
 
    XCTAssertTrue([self.vc.tableView numberOfRowsInSection:0] ==expectedRows, @"Table has %ld rows but it should have %ld", (long)[self.vc.tableView numberOfRowsInSection:0],(long)expectedRows);
    
}

- (void)testTableViewCellCreateCellsWithReuseIdentifier
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.vc.tableView cellForRowAtIndexPath:indexPath];
    NSString *expectedReuseIdentifier = [NSString stringWithFormat:@"%ld/%ld",(long)indexPath.section,(long)indexPath.row];
    XCTAssertTrue([cell.reuseIdentifier isEqualToString:expectedReuseIdentifier], @"Table does not create reusable cells");
}


@end