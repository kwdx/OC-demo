//
//  MainTableViewController.m
//  Runloop Load Image
//
//  Created by warden on 2018/3/12.
//  Copyright © 2018年 warden. All rights reserved.
//

#import "MainTableViewController.h"
#import "TableViewController.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LoadImage"]) {
        TableViewController *tableVC = (TableViewController *)segue.destinationViewController;
        tableVC.type = [sender integerValue];
    }
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"LoadImage" sender:@(indexPath.row)];
}

@end
