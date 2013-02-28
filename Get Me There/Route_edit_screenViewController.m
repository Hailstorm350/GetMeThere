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
#import "Event.h"
#import "Route.h"
#import "Get_Me_ThereAppDelegate.h"
@implementation Route_edit_screenViewController
@synthesize context=_context;
@synthesize fetchedResultsController = _fetchedResultsController, inheritedIndexRow, inheritedName, inheritedRoute;
BOOL didCreateNew;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSManagedObjectContext *thisContext=[[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    //WAS "EVENT"////////////////////////////////////////////////////////////////////////////////////////
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:thisContext];
    [fetchRequest setEntity:entity];
    NSLog(@"in fetchedresultscontroller predicate: name is %@", inheritedRoute.Name);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"route.Name=%@", inheritedRoute.Name];
    
    [fetchRequest setPredicate:predicate];   
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"Row" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:thisContext sectionNameKeyPath:nil 
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = theFetchedResultsController.delegate;
    NSArray *sections = theFetchedResultsController.sections;
    int someSection = 0;
    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:someSection];
    int numberOfObjects = [sectionInfo numberOfObjects];
    NSLog(@"nuberOfObjects=%d", numberOfObjects);
    [sort release];
    [fetchRequest release];
    [theFetchedResultsController release];
    
    return _fetchedResultsController;    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSError *error;
    NSLog(@"Here");
    NSLog(@"index row is %d", inheritedIndexRow);
    //NSLog(@"Route is %@", inheritedName);
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1); 
    }
    
    //    if (![UIImagePickerController isSourceTypeAvailable:
    //		  UIImagePickerControllerSourceTypeCamera]) {
    //		takePictureButton.hidden = YES;
    //		selectFromCameraRollButton.hidden = YES;
    //	}
    /*
    NSManagedObjectContext *thisContext=[[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Route" inManagedObjectContext:thisContext];
    
    [request setEntity:entity];
     
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name=%@", inheritedName];
        
        [request setPredicate:predicate];
    
    NSArray *array = [thisContext executeFetchRequest:request error:&error];
    Route *info;
    if([array count]==1){
        info=[array objectAtIndex:0];
        [_fetchedResultsController.fetchRequest setPredicate:predicate];
    }
    else
        NSLog(@"Not here!");
    NSLog(@"Route name is %@", info.Name);
    */
    self.title = @"Events";
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
	
    [super viewDidUnload];
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    /*NSError *error;

    NSManagedObjectContext *thisContext=[[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Route" inManagedObjectContext:thisContext];
    
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name=%@", inheritedName];
    
    [request setPredicate:predicate];
    
    NSArray *array = [thisContext executeFetchRequest:request error:&error];
    Route *info;
    if([array count]==1){
        info=[array objectAtIndex:0];
        [_fetchedResultsController.fetchRequest setPredicate:predicate];
    }
    else
        NSLog(@"Not here!");
    NSLog(@"Route name is STILL %@", info.Name);
    NSSet *eventSet = info.Event;
    NSArray *objectsArray = [eventSet allObjects];
    NSLog(@"the number of events so far is %d", [objectsArray count]);
    //Event.info *hello= [_fetchedResultsController objectAtIndexPath:indexPath];
    NSLog(@"The text label should say %@", info.Name);
    */
  //  NSSet *allOfMyEventsInTheList=inheritedRoute.Event;
   // NSArray *objects=[allOfMyEventsInTheList allObjects];
    NSArray *allEvents = 
    [[[_fetchedResultsController sections] objectAtIndex:0] objects];

    Event *info = [allEvents objectAtIndex:indexPath.row];
    NSLog(@"the number of objects in the array is %d and the index path is %d, and the events row number is %d", [allEvents count], indexPath.row, [info.Row integerValue]);
    cell.textLabel.text=info.Name;
    NSLog(@"info.Arrow=%@", info.Arrow);
    if([info.Arrow isEqualToString:@"straight"]){
        cell.imageView.image=[UIImage imageNamed:@"straight.png"];
    }
    else if([info.Arrow isEqualToString:@"slight right"]){
        cell.imageView.image=[UIImage imageNamed:@"slight right.png"];
    }
    else if([info.Arrow isEqualToString:@"Right"]){
        cell.imageView.image=[UIImage imageNamed:@"right turn.png"];
    }
    else if([info.Arrow isEqualToString:@"slight left"]){
        cell.imageView.image=[UIImage imageNamed:@"slight left.png"];
    }
    else if([info.Arrow isEqualToString:@"Left"]){
        NSLog(@"here i am");
        cell.imageView.image=[UIImage imageNamed:@"left turn.png"];
        
    }
     
}

-(NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = 
    [[_fetchedResultsController sections] objectAtIndex:0];
 //   NSSet *allOfMyEventsInTheList=inheritedRoute.Event;
 //   NSArray *objects=[allOfMyEventsInTheList allObjects];
 //   NSLog(@"number of rows in section is %d", [objects count]);
 //   return [objects count]+2;
    NSLog(@"number of rows in section is %d", [sectionInfo numberOfObjects]);
    return ([sectionInfo numberOfObjects]+2);
}

//The program never reaches this function!
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"MediaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    if(indexPath.row==[[_fetchedResultsController fetchedObjects]count]){
        cell.textLabel.text=@"Create a new Event...";
        cell.imageView.image=[UIImage imageNamed:@"plus sign.png"];
        
    }
    else if(indexPath.row==[[_fetchedResultsController fetchedObjects]count]+1)
    {
        cell.textLabel.text=@"Back";
        cell.imageView.image=[UIImage imageNamed:@"back button.png"];

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
    
    edit_modal_screen *editer=[[edit_modal_screen alloc]init];
    if(indexPath.row==[[_fetchedResultsController fetchedObjects] count]+1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    else if(indexPath.row==[[_fetchedResultsController fetchedObjects] count]+2)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }

    if(indexPath.row==[[_fetchedResultsController fetchedObjects] count]){
        didCreateNew=TRUE;
        editer.newEvent=TRUE;
    }
    else{
        didCreateNew=FALSE;
        editer.newEvent=FALSE;
        Event *info = [_fetchedResultsController objectAtIndexPath:indexPath];
        NSLog(@"I'm passing to the modal screen the event %@, which has the properties %@", info.Name, info.Transit);
        editer.inheritedEvent=info;
        editer.givenName=info.Name;
    }
    editer.fetchedResultsControllerInherited=_fetchedResultsController;
    //editer.modalScreenEventData=eventData;
    editer.finalInheritedRoute=inheritedRoute;
    NSArray *allEvents = 
    [[[_fetchedResultsController sections] objectAtIndex:0] objects];
    editer.indexRow=[allEvents count];
    NSLog(@"the count of the array passed in is %d", [allEvents count]);
    [self presentViewController:editer animated:YES completion: nil];
    [editer release];
}


- (void)dealloc
{
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    
    //[eventData release];
    [super dealloc];
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