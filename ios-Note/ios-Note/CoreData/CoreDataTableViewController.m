//
//  CoreDataTableViewController.m
//  Note
//
//  Created by SL on 28/03/2017.
//  Copyright © 2017 Sam. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "CoreDataManager.h"

static NSString * const cellIdentifier = @"coreDataCell";

@interface CoreDataTableViewController ()
@property (strong, nonatomic) CoreDataManager *CDManager;

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation CoreDataTableViewController

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

#pragma mark- Customer Accessors
- (CoreDataManager *)CDManager {
    if (_CDManager == nil) {
        _CDManager = [[CoreDataManager alloc] init];
    }
    return _CDManager;
}
- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithArray:[self executeCoreData]];
    }
    return _dataSource;
}

#pragma mark- methods

- (IBAction)addModel:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加Model" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"添加" style:0 handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = alertController.textFields[0];
        
        //CoreData 添加数据
        NSManagedObjectContext *context = self.CDManager.persistentContainer.viewContext;
        Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
        person.name = tf.text;
        [self.CDManager saveContext];
        
        [self.dataSource addObject:person];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:0 handler:nil];
    [alertController addTextFieldWithConfigurationHandler:nil];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (NSArray *)executeCoreData
{
    NSManagedObjectContext *context = self.CDManager.persistentContainer.viewContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];
    if (error != nil) {
        NSLog(@"executeRequest error %@, %@", error, [error userInfo]);
        result = nil;
    } else {
        
        //        self.dataSource = [NSMutableArray arrayWithArray:result];
        NSLog(@"%@",result);
    }
    return result;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    //cell 界面数据加载
    Person *person = self.dataSource[indexPath.row];
    cell.textLabel.text = person.name;

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"修改Model" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"修改" style:0 handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = alertController.textFields[0];
        
        //CoreData 修改数据
        Person *person = self.dataSource[indexPath.row];
        person.name = tf.text;
        [self.CDManager saveContext];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:0 handler:nil];
    [alertController addTextFieldWithConfigurationHandler:nil];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__func__);
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSManagedObjectContext *context = self.CDManager.persistentContainer.viewContext;
        Person *person = self.dataSource[indexPath.row];
        [context deleteObject:person];
        [self.CDManager saveContext];
        
        [self.dataSource removeObjectAtIndex:indexPath.row];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
