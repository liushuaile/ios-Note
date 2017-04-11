//
//  GCDTableViewController.m
//  Note
//
//  Created by SL on 28/03/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "GCDTableViewController.h"
#import "GCDMethods.h"

static NSString * const cellReuseIdentifier = @"cell";

@interface GCDTableViewController ()
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) GCDMethods *gcdMethods;
@end

@implementation GCDTableViewController

#pragma mark- Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- custom accesses
- (NSArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSArray arrayWithObjects:@"并发队列 + 同步执行",@"并发队列 + 异步执行",@"串行队列 + 同步执行",@"串行队列 + 异步执行",@"主队列 + 同步执行",@"主队列 + 异步执行",@"线程通信",@"栅栏",@"延时执行",@"一次性执行",@"快速迭代",@"队列组 ", nil];
    }
    return _dataArray;
}

- (GCDMethods *)gcdMethods {
    if (_gcdMethods == nil) {
        _gcdMethods = [[GCDMethods alloc] init];
    }
    return _gcdMethods;
}

#pragma mark- private methods

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:cellReuseIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
            [self.gcdMethods syncConcurrent];
            break;
        case 1:
            [self.gcdMethods asyncConcurrent];
            break;
        case 2:
            [self.gcdMethods syncSerial];
            break;
        case 3:
            [self.gcdMethods asyncSerial];
            break;
        case 4:
            [self.gcdMethods syncMain];
            break;
        case 5:
            [self.gcdMethods asyncMain];
            break;
        case 6:
            [self.gcdMethods backMain];
            break;
        case 7:
            [self.gcdMethods barrier];
            break;
        case 8:
            [self.gcdMethods after];
            break;
        case 9:
            [self.gcdMethods once];
            break;
        case 10:
            [self.gcdMethods apply];
            break;
        case 11:
            [self.gcdMethods group];
            break;
            
        default:
            break;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
