//
//  Where_Am_IViewController.m
//  Get Me There
//
//  Created by joseph schneider on 4/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import "Where_Am_IViewController.h"
#import "UserManual.h"
#import "Guardian_Home_Screen.h"
#import "beginningCell.h"
#import "Route.h"
#import "Get_Me_ThereAppDelegate.h"
#import "ShowPrimaryDirection.h"
@implementation Where_Am_IViewController
@synthesize context=_context, fetchedResultsController=_fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        NSLog(@"HERE WE GO!");
        return _fetchedResultsController;
    }
    NSManagedObjectContext *thisContext=[[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Route" inManagedObjectContext:thisContext];    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"Row" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:thisContext sectionNameKeyPath:nil 
                                                   cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    [sort release];
    [fetchRequest release];
    [theFetchedResultsController release];
    
    return _fetchedResultsController;    
    
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
- (void)dealloc
{
    [super dealloc];
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
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
    [super viewDidLoad];
    NSLog(@"checking how many times it loads...");
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Information" style:UIBarButtonItemStyleBordered target:self action:@selector(informationButtonPressed)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Guardian" style:UIBarButtonItemStyleBordered target:self action:@selector(GuardianButtonPressed)];
    self.navigationItem.leftBarButtonItem = leftButton;
   // [self.tableView reloadData];

    self.title = @"Route";   
}



- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"here i want to reload!!!");
    self.fetchedResultsController=nil;
    NSError *error;

    if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Information" style:UIBarButtonItemStyleBordered target:self action:@selector(informationButtonPressed)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Guardian" style:UIBarButtonItemStyleBordered target:self action:@selector(GuardianButtonPressed)];
    self.navigationItem.leftBarButtonItem = leftButton;
    // [self.tableView reloadData];
    
    self.title = @"Route";   

    [self.tableView reloadData];
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    [super viewWillAppear:animated]; 
    
//    NSError *error;
//	if (![[self fetchedResultsController] performFetch:&error]) {
//		// Update to handle the error appropriately.
//		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//		exit(-1);  // Fail
//	}


	
}

- (void)viewDidUnload
{
    //[super viewDidUnload];
    self.fetchedResultsController = nil;
    self.fetchedResultsController=nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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

-(IBAction) informationButtonPressed
{
    NSLog(@"It is pressed2");
    
    UserManual *information=[[UserManual alloc]init];
    [self presentModalViewController:information animated:YES];
    [information release];
}
-(IBAction) GuardianButtonPressed{
    NSLog(@"It is pressed");
    Guardian_Home_Screen *information=[[Guardian_Home_Screen alloc]initWithNibName:@"Guardian_Home_Screen" bundle:nil];
    
    [self.navigationController pushViewController:information animated:YES];
    UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = _backButton;
    
    // [_backButton release], _backButton = nil;
    // [information release], _myViewController = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = 
    [[_fetchedResultsController sections] objectAtIndex:section];
    NSLog(@"The number of objects is %d", [sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}


- (void)configureCell:(beginningCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Route *info = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.test.text=info.Name;
    UIImage *temp = [UIImage imageWithData: info.StartPicture];
    cell.startPicture.image = temp;
    UIImage *temp2 = [UIImage imageWithData: info.DestinationPicture];
    cell.endPicture.image = temp2;
    NSLog(@"the cell should say %@", cell.test.text);
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"the current row is %d", indexPath.row);
    static NSString *cellIdentifier=@"beginningCell";
    beginningCell *cell = (beginningCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        //cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        NSArray *TopLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"beginningCell" owner:self options:nil];
        for(id currentObject in TopLevelObjects){
            if([currentObject isKindOfClass:[beginningCell class]]){
                cell=(beginningCell *) currentObject;
                break;
            }
        }
    }
    [self configureCell:cell atIndexPath:indexPath];

    /* for(int i=0; i<=[eventData numberOfEvents]; i++)
     {
     if(indexPath.row==[eventData numberOfEvents])
     cell.textLabel.text=@"Create a new Event...";
     else
     {
     Event_class *specificEvent = [eventData getMemberAtIndex:indexPath.row];
     NSString *memberName =[specificEvent descriptionOfEvent];
     if(specificEvent.goStraight==TRUE)
     cell.imageView.image = [UIImage imageNamed:@"straight.png"];
     else if(specificEvent.rightTurn==TRUE)
     if(specificEvent.slightTurn==TRUE)
     cell.imageView.image = [UIImage imageNamed:@"slight right.png"];
     else
     cell.imageView.image = [UIImage imageNamed:@"right turn.png"];
     else
     if(specificEvent.slightTurn==TRUE)
     cell.imageView.image = [UIImage imageNamed:@"slight left.png"];
     else
     cell.imageView.image = [UIImage imageNamed:@"left turn.png"];
     
     cell.textLabel.text=memberName;
     }
     }    
     */  return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Route *primaryDirection=[_fetchedResultsController objectAtIndexPath:indexPath];
    ShowPrimaryDirection *information=[[ShowPrimaryDirection alloc]init];
    information.currentEvent=0;
    information.routeName=primaryDirection.Name; 
    [self.navigationController pushViewController:information animated:YES];
    
}



- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    NSLog(@"begin updates?");
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:(beginningCell *) [tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    NSLog(@"it's over!");
    [self.tableView endUpdates];
}

@end
