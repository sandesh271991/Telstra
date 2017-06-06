//
//  ViewController.m
//  Telstra
//
//  Created by LION-2 on 5/31/17.
//  Copyright © 2017 Infosys. All rights reserved.
//

#import "ViewController.h"
//#import <SDWebImage/UIImageView+WebCache.h>
//#import <UIImageView+WebCache.h>
//#import "SDWebImageManager.h"
#import "APIDataFetcher.h"

#define API_URL @"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"


@interface ViewController () <UITableViewDelegate,UITableViewDataSource, NSURLSessionDelegate>

@property (nonatomic, assign) NSString *navigationTitle;
@property (nonatomic, assign)  UINavigationBar *myNav;


@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    [self cofigureTableview];
    
    self.content = [[NSMutableArray alloc]init];
    self.navigationTitle = @" ";
    [self fetchData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}


//MARK: Tableview Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.content.count > 0) {
        return _content.count ;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    
    if (self.content.count > 0){
       
        NSDictionary *contentdata = self.content[indexPath.row];
        
        NSString *title = contentdata[@"description"];
        NSString *imageUrlString = contentdata[@"imageHref"];
       // NSString *description = contentdata[@"title"];
        
        cell.textLabel.text =  [title isKindOfClass:[NSNull class]] ? @"" : title;  //----- Title
        cell.imageView.image = [UIImage imageNamed:@"demoImg.png"];
       //cell.detailTextLabel.text  =  [description isKindOfClass:[NSNull class]] ? @"" : description;  //----- Description
     
        cell.contentView.layer.borderColor = [UIColor blackColor].CGColor;
        cell.contentView.layer.borderWidth = 1.0;


        //----------- Image asynchronous Downloading ------(start)------------
        
        
        //---- using SDWebImage framework
//                if(![imageUrlString isKindOfClass:[NSNull class]]){
//                        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
//                                          placeholderImage:nil
//                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                                     if (error) {
//                                                         NSLog(@"Error occured : %@", [error description]);
//                                                     }
//                                                 }];
//                }
        
        
        //------------ using GCD ---------
        if(![imageUrlString isKindOfClass:[NSNull class]]){
            
            dispatch_async(dispatch_get_global_queue(0,0), ^{
               NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrlString]];
                if ( data == nil )
                    return;
                dispatch_async(dispatch_get_main_queue(), ^{
                    // WARNING: is the cell still using the same data by this point??
                    cell.imageView.image = [UIImage imageWithData: data];
                });
            });
        }
        //------------ using GCD -----
        
        
        //----------- Image asynchronous Downloading -----------(end)------------
        
        //------ alternate cell color ------
        if(indexPath.row % 2 == 0){
            UIColor *cellColour = [[UIColor alloc] initWithRed: 231.0/255.0 green: 231.0/255.0 blue: 231.0/255.0 alpha: 1.0];
            cell.backgroundColor = cellColour;
        }
    }
 

    //--------- for multiline cell ------------
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.translatesAutoresizingMaskIntoConstraints = NO;
    return cell;
}


//MARK: Custom Methods

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self cofigureTableview];
    [self addNavigationBar];
    
}



//----------------- api call ------------------------------
-(void)fetchData{
    
    [APIDataFetcher loadDataFromAPI:API_URL parameter:nil callback:^(NSDictionary *jsonDict, NSError *error) {
        if (error == nil) {
            NSLog(@" %@",jsonDict);
            self.content = jsonDict[@"rows"];
            self.navigationTitle = jsonDict[@"title"];
            NSLog(@"navigationTitle %@", self.navigationTitle);
            
            [self addNavigationBar];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                
            });
        }
    }];
}


-(void)cofigureTableview
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //--- For dynamic height
    self.tableView.estimatedRowHeight = 500;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(52,0,0,0);
    
    [self.view addSubview:self.tableView];
}

//--- Add navigation bar to ViewController
-(void)addNavigationBar {
    UINavigationBar *myNav = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [UINavigationBar appearance].barTintColor = [UIColor lightGrayColor];
    
    myNav.tag = 1001;
    
    [self.view addSubview:myNav];
    
    UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:self.navigationTitle];
    myNav.items = [NSArray arrayWithObjects: navigItem,nil];
}

@end
