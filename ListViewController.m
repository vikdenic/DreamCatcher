//
//  ListViewController.m
//  DreamTrack
//
//  Created by Johnny Appleseed on 11/11/14.
//  Copyright (c) 2014 MobileMakers. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *titlesArray;
@property NSMutableArray *descriptionsArray;

@end

@implementation ListViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titlesArray = [NSMutableArray new];
    self.descriptionsArray = [NSMutableArray new];
}


#pragma mark - UITableViewDelegate methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if(indexPath.row == (self.titlesArray.count) && self.editing)
    {
        cell.textLabel.text = @"add new row";
        return cell;
    }

    cell.textLabel.text = [self.titlesArray objectAtIndex:indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger count = self.titlesArray.count;

    if (self.editing == true)
    {
        count++;
    }

    return count;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.titlesArray removeObjectAtIndex:indexPath.row];
        [self.descriptionsArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        [self presentEntryAlert];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString *titleItem = [self.titlesArray objectAtIndex:fromIndexPath.row];
    [self.titlesArray removeObject:titleItem];
    [self.titlesArray insertObject:titleItem atIndex:toIndexPath.row];

    NSString *descriptionItem = [self.descriptionsArray objectAtIndex:fromIndexPath.row];
    [self.descriptionsArray removeObject:descriptionItem];
    [self.descriptionsArray insertObject:descriptionItem atIndex:toIndexPath.row];
    [self.tableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editing == NO || !indexPath)
    {
        return UITableViewCellEditingStyleNone;
    }

    if (self.editing && indexPath.row == self.titlesArray.count)
    {
        return UITableViewCellEditingStyleInsert;
    }
    
    else
    {
        return UITableViewCellEditingStyleDelete;
    }

    return UITableViewCellEditingStyleNone;
}

#pragma mark - Button Actions
- (IBAction)onAddButtonTapped:(UIBarButtonItem *)sender
{
    [self presentEntryAlert];
}

- (IBAction)onEditButtonTapped:(UIBarButtonItem *)sender
{
    if (self.editing)
    {
        self.editing = false;
        [self.tableView setEditing:false animated:true];
        sender.style = UIBarButtonItemStylePlain;
        sender.title = @"Edit";
    }
    else
    {
        self.editing = true;
        [self.tableView setEditing:true animated:true];
        sender.title = @"Done";
        sender.style =  UIBarButtonItemStyleDone;
    }
    [self.tableView reloadData];
}

#pragma mark - Helpers
-(void)presentEntryAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter Dream" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Dream Title";
    }];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Dream description";
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        UITextField *textFieldOne = alertController.textFields[0];
        [self.titlesArray addObject:textFieldOne.text];

        UITextField *textFieldTwo = alertController.textFields[1];
        [self.descriptionsArray addObject:textFieldTwo.text];

        [self.tableView reloadData];
    }];

    [alertController addAction:cancelAction];
    [alertController addAction:saveAction];

    [self presentViewController:alertController animated:true completion:nil];
}

#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DetailViewController *detailViewController = segue.destinationViewController;
    detailViewController.titleString = [self.titlesArray objectAtIndex: self.tableView.indexPathForSelectedRow.row];
    detailViewController.descriptionString = [self.descriptionsArray objectAtIndex: self.tableView.indexPathForSelectedRow.row];
}

@end
