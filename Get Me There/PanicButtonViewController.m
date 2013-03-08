//
//  PanicButtonViewController.m
//  PanicButton
//
//  Created by monica dimalanta camorongan on 2/24/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "PanicButtonViewController.h"
#import "PanicButtonInfo.h"
#import "PanicButtonDetails.h"
#import "EditContactViewController.h"
#import "Get_Me_ThereAppDelegate.h"

@implementation PanicButtonViewController
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context, myTableView;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        //NSLog(@"HELLO THERE!");
        return _fetchedResultsController;
    }
    NSManagedObjectContext *thisContext=[[Get_Me_ThereAppDelegate sharedAppDelegate]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PanicButtonInfo" inManagedObjectContext:thisContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"details.phone" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:thisContext sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = (id<NSFetchedResultsControllerDelegate>) self;
    
    [sort release];
    [fetchRequest release];
    [theFetchedResultsController release];
    
    return _fetchedResultsController;
}

- (IBAction)toggleEdit {
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    if(self.tableView.editing) {
//        NSLog(@"if of toggleEdit");
        [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
        [self.navigationItem.leftBarButtonItem setTitle:@"+New"];
        [self.navigationItem.leftBarButtonItem setAction:@selector(toggleAdd)];
    }else {
//        NSLog(@"else of toggleEdit");
        [self.navigationItem.rightBarButtonItem setTitle:@"Edit"];
        [self.navigationItem.leftBarButtonItem setTitle:@"Back"];
        [self.navigationItem.leftBarButtonItem setAction:@selector(backButtonPressed)];
    }
}

- (IBAction)toggleAdd {
    //NSManagedObjectContext *context = _context;
    NSManagedObjectContext *context=[[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    PanicButtonInfo *panicButtonInfo = [NSEntityDescription 
                                        insertNewObjectForEntityForName:@"PanicButtonInfo" 
                                        inManagedObjectContext:context];
    panicButtonInfo.name = @"New Contact";
    PanicButtonDetails *panicButtonDetails = [NSEntityDescription 
                                              insertNewObjectForEntityForName:@"PanicButtonDetails" 
                                              inManagedObjectContext:context];
    panicButtonDetails.phone = @"1234";   
    panicButtonDetails.info = panicButtonInfo;
    panicButtonInfo.details = panicButtonDetails;
    
    /*NSMutableArray *list = [[_fetchedResultsController fetchedObjects] mutableCopy];
    int i = 0;
    for(PanicButtonInfo *person in list){
        PanicButtonDetails *details = person.details;
        [details setValue:[NSNumber numberWithInt:i++] forKey:@"details.displayOrder"];
    }
    [list release], list = nil;
    [_context save:nil];
    */
    
    EditContactViewController *detailViewController = [[EditContactViewController alloc] initWithNibName:@"EditContactViewController" bundle:nil];
    detailViewController.givenName = panicButtonInfo.name;
        
    [self presentModalViewController:detailViewController animated:YES];
    [detailViewController release];

}

- (IBAction)backButtonPressed
{
    NSLog(@"Let me out!");
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    self.context = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    /*Old Method
     NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName: @"PanicButtonInfo" 
                                   inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
     */
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        //Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1); //Fail.
    }
    self.title = @"Panic Contacts";
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEdit)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [editButton release];
    [leftButton release];
    [super viewDidLoad];
    
    //Old Method cont. [fetchRequest release];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    self.fetchedResultsController = nil;
    //[super viewDidUnload];
    self.fetchedResultsController = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
    
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return [_panicButtonInfos count];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    PanicButtonInfo *info = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = info.name;
    PanicButtonDetails *details = info.details;
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", details.phone];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                                 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    /*Old Way...
    PanicButtonInfo *info = [_panicButtonInfos 
                             objectAtIndex:indexPath.row];
    cell.textLabel.text = info.name;
    PanicButtonDetails *details = info.details;
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", details.phone];*/
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSManagedObjectContext *context = [[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];       
        [context deleteObject:[_fetchedResultsController objectAtIndexPath:indexPath]];
        NSError *error;
        if (![context save: &error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);
        }
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}



// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Deselect the row once the user makes a choice
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Navigation logic may go here. Create and push another view controller.

    EditContactViewController *detailViewController = [[EditContactViewController alloc] initWithNibName:@"EditContactViewController" bundle:nil];
    
    PanicButtonInfo *contactInfo = [_fetchedResultsController objectAtIndexPath:indexPath];
    detailViewController.givenName = contactInfo.name;
    
     // Pass the selected object to the new view controller.
     [self presentModalViewController:detailViewController animated:YES];
     [detailViewController release];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView  cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates]; 
}
@end
