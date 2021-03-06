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
@synthesize context, fetchedResultsController=_fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Route" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                                  initWithKey:@"sortOrder" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
        [fetchRequest setFetchBatchSize:20];
        
        NSFetchedResultsController *theFetchedResultsController = 
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                            managedObjectContext:context sectionNameKeyPath:nil
                                                       cacheName:nil];
        self.fetchedResultsController = theFetchedResultsController;
        _fetchedResultsController.delegate = (id<NSFetchedResultsControllerDelegate>) self;

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
    
    if(self.context == nil)
        self.context = [[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    
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

    self.title = @"Routes";   
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
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


-(IBAction) informationButtonPressed
{
    
    UserManual *information=[[UserManual alloc]init];
    [self presentModalViewController:information animated:YES];
//    [information release];
}
-(IBAction) GuardianButtonPressed{
    
    Guardian_Home_Screen *guardianView=[[Guardian_Home_Screen alloc]initWithNibName:@"Guardian_Home_Screen" bundle:nil];
    
    [self.navigationController pushViewController:guardianView animated:YES];
    UIBarButtonItem *_backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = _backButton;
    
//    [_backButton release], _backButton = nil;
//    [information release];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = 
    [[_fetchedResultsController sections] objectAtIndex:0];
    //NSLog(@"The number of Routes is %d", [sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}


- (void)configureCell:(beginningCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Route *info = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    ((UILabel *)[cell viewWithTag:3]).text=info.name;
    NSLog(@"in ConfigureCell. startURL: %@ ; destURL: %@ \nRoute is: %@",info.startPictureURL, info.destinationPictureURL, info);

    //Tell cell to load route's start and end images
    [cell setUIImages:[NSURL URLWithString: info.startPictureURL]:[NSURL URLWithString:info.destinationPictureURL]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"beginningCell";
    beginningCell *cell = (beginningCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        NSArray *TopLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"beginningCell" owner:self options:nil];
        for(id currentObject in TopLevelObjects){
            if([currentObject isKindOfClass:[beginningCell class]]){
                cell=(beginningCell *) currentObject;
                break;
            }
        }
    }
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Route *primaryDirection = [_fetchedResultsController objectAtIndexPath:indexPath];
    ShowPrimaryDirection *naviView = [[ShowPrimaryDirection alloc] initWithRoute: primaryDirection.name];
    [self.navigationController presentModalViewController:naviView animated:YES];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
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
    //NSLog(@"it's over!");
    [self.tableView endUpdates];
}

- (BOOL) shouldAutorotate{
    
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end
