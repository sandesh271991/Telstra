//
//  ViewController.h
//  Telstra
//
//  Created by LION-2 on 5/31/17.
//  Copyright © 2017 Infosys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    
}
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *content;


////

@property(nonatomic, readonly) UILabel *factTitleLabel;
@property(nonatomic, readonly) UILabel *factDescriptionLabel;
@property(nonatomic, readonly) UIImageView *factImageView;


///

@end

