//
//  ViewController.m
//  Telstra
//
//  Created by LION-2 on 5/31/17.
//  Copyright © 2017 Infosys. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController () <UITableViewDelegate,UITableViewDataSource, NSURLSessionDelegate>

@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *content;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalItems;
@property (nonatomic, assign) NSInteger maxPages;
@property (nonatomic, strong) NSMutableArray *photos;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cofigureTableview];
    
    //--- For dynamic height
    self.tableView.estimatedRowHeight = 20;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.content = [[NSMutableArray alloc]init];
    
    [self fetchData];
}

-(void)cofigureTableview
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}



 //MARK: Tableview Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    if (self.content.count > 0) {
    //     return   _content.count ;
    //    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    if (self.content.count > 0){
        NSDictionary *contentdata = self.content[indexPath.row];
        
        NSString *title = contentdata[@"title"];
        NSString *imageUrlString = contentdata[@"imageHref"];
        
        cell.textLabel.text =  [title isKindOfClass:[NSNull class]] ? @"snde ksfh igwuyg fiweghfuyuyg hkjsv guyeg fsvnjhg yuegfg ejf hsgyue ghgjgg eryugegt uweht uy" : title;
        
        
        //        NSDictionary *photoItem = self.photos[indexPath.row];
        //cell.textLabel.text = [contentdata objectForKey:@"name"];
        //        if (![[contentdata objectForKey:@"description"] isEqual:[NSNull null]]) {
        //            cell.detailTextLabel.text = [photoItem objectForKey:@"description"];
        //        }
        
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[contentdata objectForKey:@"imageHref"]]
//                          placeholderImage:[UIImage imageNamed:@""]
//                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                     if (error) {
//                                         NSLog(@"Error occured : %@", [error description]);
//                                     }
//                                 }];
        
        
        
        
        
        
        //        dispatch_async(dispatch_get_global_queue(0,0), ^{
        //            NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: @"http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"]];
        //            if ( data == nil )
        //                return;
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                // WARNING: is the cell still using the same data by this point??
        //                cell.imageView.image = [UIImage imageWithData: data];
        //            });
        //        });
    }
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // NSLog(@"title of cell %@", [_content objectAtIndex:indexPath.row]);
}



//---- api call --
-(void)fetchData{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"]];
    [request setHTTPMethod:@"GET"];
    [request addValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"text/plain" forHTTPHeaderField:@"Accept"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSData * responseData = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
        if (responseData != nil) {
            
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
            NSLog(@"requestReply: %@", jsonDict);
            self.content = jsonDict[@"rows"];
            [self.tableView reloadData];
            
            NSLog(@"result %@", self.content);
            
        }
        
    }] resume];
    
    
}




@end
