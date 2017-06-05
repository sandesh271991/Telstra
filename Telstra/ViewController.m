//
//  ViewController.m
//  Telstra
//
//  Created by LION-2 on 5/31/17.
//  Copyright © 2017 Infosys. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <UIImageView+WebCache.h>
#import "SDWebImageManager.h"


@interface ViewController () <UITableViewDelegate,UITableViewDataSource, NSURLSessionDelegate>

//@property (strong,nonatomic) UITableView *tableView;
//@property (strong,nonatomic) NSMutableArray *content;
@property (nonatomic, assign) NSString *navigationTitle;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self cofigureTableview];
    
    [self addNavigationBar];
    
    self.content = [[NSMutableArray alloc]init];
    self.navigationTitle = @" ";
    
    
    [self fetchData];
}

-(void)cofigureTableview
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //--- For dynamic height
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.contentInset = UIEdgeInsetsMake(52,0,0,0);
    
    [self.view addSubview:self.tableView];
}


-(void)addNavigationBar {
    UINavigationBar *myNav = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    [UINavigationBar appearance].barTintColor = [UIColor lightGrayColor];
    myNav.tag = 1001;
    
    [self.view addSubview:myNav];
    
    UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:@"Title"];
    myNav.items = [NSArray arrayWithObjects: navigItem,nil];
}


//MARK: Tableview Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.content.count > 0) {
        return   _content.count ;
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
        //NSString *description = contentdata[@"description"];
        
        cell.textLabel.text =  [title isKindOfClass:[NSNull class]] ? @"" : title;  //----- Title
        cell.imageView.image = [UIImage imageNamed:@"demoImg.png"];
        //cell.detailTextLabel.text  =  [description isKindOfClass:[NSNull class]] ? @"" : description;  //----- Description
        
        
        
        //---- Navigation Title
        UINavigationBar *myNav = (UINavigationBar *)[self.view viewWithTag:1001];
//        UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:self.navigationTitle];
//        myNav.items = [NSArray arrayWithObjects: navigItem,nil];
        
               
        
        //----------- Image asynchronous Downloading ------(start)------------
   
        
        //---- using SDWebImage framework
//        if(![imageUrlString isKindOfClass:[NSNull class]]){
//                [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]
//                                  placeholderImage:nil
//                                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                                             if (error) {
//                                                 NSLog(@"Error occured : %@", [error description]);
//                                             }
//                                         }];
//        }
//        if(![imageUrlString isKindOfClass:[NSNull class]]){
//
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@"https://static.pexels.com/photos/115045/pexels-photo-115045.jpeg"]
//                          placeholderImage:UIImage(named: "demoImg")];
//        }
        
//         if(![imageUrlString isKindOfClass:[NSNull class]]){
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString]];
//         }
        //cell.imageView.sd_setImage(with: URL(string: imageUrlString), placeholderImage: UIImage(named: "demoImg.png"))

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
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
   
    [self cofigureTableview];
    //[self.tableView reloadData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self addNavigationBar];


}




//----------------- api call ------------------------------
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
            self.navigationTitle = jsonDict[@"title"];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                
            });
            
            NSLog(@"result %@", self.content);
            
        }
        
    }] resume];
    
    
}



@end
