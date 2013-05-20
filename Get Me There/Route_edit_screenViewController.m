//
//  Route_edit_screenViewController.m
//  Get Me There
//
//  Created by joseph schneider on 4/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "Route_edit_screenViewController.h"
#import "edit_modal_screen.h"
#import "Events_list.h"
#import "Event_class.h"
#import "destination_Picture.h"
#import "Event.h"
#import "Route.h"
#import "Get_Me_ThereAppDelegate.h"
@implementation Route_edit_screenViewController
@synthesize context;
@synthesize fetchedResultsController = _fetchedResultsController, inheritedIndexRow, inheritedName, inheritedRoute;
BOOL didCreateNew;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    @autoreleasepool {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"route.Name=%@", inheritedRoute.Name];
        
        [fetchRequest setPredicate:predicate];   
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                                  initWithKey:@"Row" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
        
        [fetchRequest setFetchBatchSize:20];
        
        NSFetchedResultsController *theFetchedResultsController = 
        [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                            managedObjectContext:context sectionNameKeyPath:nil
                                                       cacheName:nil];
        self.fetchedResultsController = theFetchedResultsController;
        _fetchedResultsController.delegate = (id<NSFetchedResultsControllerDelegate>) self;

        
        //[sort release];
        //[fetchRequest release];
        //[theFetchedResultsController release];
        
        return _fetchedResultsController;
    }
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
	
    if(self.context == nil)
        self.context = [[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    
	NSError *error;

    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);
    }
    

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = leftButton;

    self.title = @"Events";
}

- (IBAction)backButtonPressed
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:0];
    
    if([sectionInfo numberOfObjects]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Information"
                                                        message:@"You cannot create an empty route.\nThis route will be discarded."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        //[alert release];
        
        [context deleteObject:inheritedRoute];
        [context save:nil];
        
        [self.navigationController popToRootViewControllerAnimated:YES]; //Pop back to Root
    }
    else if(!inheritedRoute.DestinationPicture){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Information"
                                                        message:@"Please provide a destination picture"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        //[alert release];
    }
    else  
       [self.navigationController popToRootViewControllerAnimated:YES];
    
}


-(id)initWithStyle:(UITableViewStyle)style
{
    self= [super initWithStyle:style];
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.



- (void)viewDidUnload
{
    self.fetchedResultsController = nil;
	
    //[super viewDidUnload];
    //self.fetchedResultsController = nil;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

- (BOOL) shouldAutorotate{
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


#pragma mark - Table View data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-tableView: (UITableView *) tableView titleForHeaderInSection:(NSInteger)section
{
    return @"List of Events";
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    NSArray *allEvents = [[[_fetchedResultsController sections] objectAtIndex:0] objects];

    Event *info = [allEvents objectAtIndex:indexPath.row];
    //NSLog(@"the number of objects in the array is %d and the index path is %d, and the events row number is %d", [allEvents count], indexPath.row, [info.Row integerValue]);
    cell.textLabel.text=info.Name;
    //NSLog(@"info.Arrow=%@", info.Arrow);
    
    cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", info.Arrow]];

    
}

-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = 
    [[_fetchedResultsController sections] objectAtIndex:0];
 //   NSSet *allOfMyEventsInTheList=inheritedRoute.Event;
 //   NSArray *objects=[allOfMyEventsInTheList allObjects];
 //   NSLog(@"number of rows in section is %d", [objects count]);
 //   return [objects count]+2;
    //NSLog(@"number of rows in section is %d", [sectionInfo numberOfObjects]);
    return ([sectionInfo numberOfObjects]+2);
}

//The program never reaches this function!
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"cellForRowAtIndexPath %d", indexPath.item);
    static NSString *CellIdentifier=@"MediaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    if(indexPath.row==[[_fetchedResultsController fetchedObjects]count]){
        cell.textLabel.text=@"Create a new Event...";
        cell.imageView.image=[UIImage imageNamed:@"plus sign.png"];
        
    }
    else if(indexPath.row==[[_fetchedResultsController fetchedObjects]count]+1)
    {
        cell.textLabel.text=@"Add a destination picture";

    }
    else{
        [self configureCell:cell atIndexPath:indexPath];
    }
    return cell;
}

-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark - Table view delegate






-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if(indexPath.row==[[_fetchedResultsController fetchedObjects] count]+1)
    {
        destination_Picture *information = [[destination_Picture alloc]init];
        information.inheritedRoute = inheritedRoute;
        [self.navigationController pushViewController:information animated:YES];
        //[information release];
        return;
    }
    else if(indexPath.row==[[_fetchedResultsController fetchedObjects] count]+2)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    edit_modal_screen *editer=[[edit_modal_screen alloc]init];
    if(indexPath.row==[[_fetchedResultsController fetchedObjects] count]){
        didCreateNew=TRUE;
        editer.isNewEvent=TRUE;
    }
    else{
        didCreateNew=FALSE;
        editer.isNewEvent=FALSE;
        Event *event = [_fetchedResultsController objectAtIndexPath:indexPath];
        editer.eventObject=event;
    }

    editer.finalInheritedRoute=inheritedRoute;
    NSArray *allEvents = 
    [[[_fetchedResultsController sections] objectAtIndex:0] objects];
    editer.indexRow=[allEvents count];

    [self presentModalViewController:editer animated:YES];

}

//- (void)dealloc
//{
//    [inheritedRoute release];
//    [context release];
//    [_fetchedResultsController release], _fetchedResultsController = nil;
//    [super dealloc];
//    
//}

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
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
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
    [self.tableView endUpdates];
}

@end
