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

@implementation Where_Am_IViewController
@synthesize context=_context, fetchedResultsController=_fetchedResultsController;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        //NSLog(@"HERE WE GO!");
        return _fetchedResultsController;
    }
    NSManagedObjectContext *thisContext=[[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Route" inManagedObjectContext:thisContext];    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"Row" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:thisContext sectionNameKeyPath:nil 
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self.fetchedResultsController.delegate;
    
    [sort release];
    [fetchRequest release];
    [theFetchedResultsController release];
    
    return _fetchedResultsController;    
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
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
    [super viewDidLoad];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    self.title = @"Route";   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) informationButtonPressed
{
    NSLog(@"Information Button Pressed");
    
    UserManual *information=[[UserManual alloc]init];
    [self presentViewController:information animated:YES completion:nil];
    [information release];
}
-(IBAction) GuardianButtonPressed{
    NSLog(@"Guardian Button Pressed");
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
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    NSLog(@"The number of routes is %d", [sectionInfo numberOfObjects]);
    return [sectionInfo numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    Route *info = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.test.text=info.Name; //This is called twice for some reason
    //NSLog(@"cell.test is: %@", cell.test);
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
    //IF last row is selected, we assume it's a back button?
    if(indexPath.row==[[_fetchedResultsController fetchedObjects] count])
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    else
    {
        Route *selectedRoute =[_fetchedResultsController objectAtIndexPath:indexPath];
        //Route_edit_screenViewController *indexName = artist.artistName;
        //self.enterAlbumInfoViewController.artist = artist;
        //self.enterAlbumInfoViewController.managedObjectContext = self.managedObjectContext;
        //artist.inheritedIndexRow=indexPath.row;
        Route_edit_screenViewController *information=[[Route_edit_screenViewController alloc]init];
        //information.inheritedIndexRow=indexPath.row;
        information.inheritedName=selectedRoute.Name;
        information.inheritedRoute=selectedRoute;
        information.inheritedIndexRow=indexPath.row;
        NSLog(@"Accessing Route: %@", information.inheritedRoute.Name);
        [self.navigationController pushViewController:information animated:YES];
    }
    
}
@end
