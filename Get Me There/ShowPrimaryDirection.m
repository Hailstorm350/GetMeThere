//
//  ShowPrimaryDirection.m
//  Get Me There
//
//  Created by Monica Camorongan on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ShowPrimaryDirection.h"
#import "Panic_button_primary.h"
#import "Event.h"
#import "Route.h"
#import "Get_Me_ThereAppDelegate.h"
@implementation ShowPrimaryDirection
@synthesize directionImage, arrowImage, panicCallButton, nextDirButton, prevDirButton, routeName, currentEvent;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context;
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    @autoreleasepool {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        NSPredicate *predicate=[NSPredicate predicateWithFormat:@"route.Name=%@", routeName];
        [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"Row" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
        
        [fetchRequest setFetchBatchSize:20];
        
        NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
        self.fetchedResultsController = theFetchedResultsController;
        _fetchedResultsController.delegate = (id<NSFetchedResultsControllerDelegate>) self;

        [sort release];
        [fetchRequest release];
        [theFetchedResultsController release];
        
        return _fetchedResultsController;
    }
}

- (IBAction)contactListButtonPressed {
    //NSLog(@"DID YOU PUSH ME?!");
    //Panic_button_primary *information=[[Panic_button_primary alloc]init];
    
    [self.navigationController pushViewController:[[Panic_button_primary alloc] init] animated:YES];
}
- (IBAction)nextButtonPressed {
    currentEvent = currentEvent + 1;
    NSArray *allEvents=[[[_fetchedResultsController sections] objectAtIndex:0] objects];
    Event *info=[allEvents objectAtIndex:currentEvent];
    //Hide button if at edge
    
    //Show Arrow Image
    if([info.Arrow isEqualToString:@"straight"]){
        arrowImage.image =[UIImage imageNamed:@"straight.png"];
    }
    else if([info.Arrow isEqualToString:@"slight right"]){
        arrowImage.image =[UIImage imageNamed:@"slight right.png"];
    }
    else if([info.Arrow isEqualToString:@"Right"]){
        arrowImage.image =[UIImage imageNamed:@"right turn.png"];
    }
    else if([info.Arrow isEqualToString:@"slight left"]){
        arrowImage.image =[UIImage imageNamed:@"slight left.png"];
    }
    else if([info.Arrow isEqualToString:@"Left"]){
        arrowImage.image =[UIImage imageNamed:@"left turn.png"];
    }
    
    //Show Directional Image
    UIImage *temp = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: info.Picture]]];
    directionImage.image = temp;
    
    int rows = [allEvents count] - 1;
    if (currentEvent == rows)
        nextDirButton.hidden = YES;
    else
        nextDirButton.hidden = NO;
    if(currentEvent == 0)
        prevDirButton.hidden = YES;
    else if(currentEvent != 0)
        prevDirButton.hidden = NO;
    
}
- (IBAction)prevButtonPressed {
    currentEvent = currentEvent - 1;
    NSArray *allEvents=[[[_fetchedResultsController sections] objectAtIndex:0] objects];
    Event *info=[allEvents objectAtIndex:currentEvent];
    
    //Show Arrow Image
    if([info.Arrow isEqualToString:@"straight"]){
        arrowImage.image =[UIImage imageNamed:@"straight.png"];
    }
    else if([info.Arrow isEqualToString:@"slight right"]){
        arrowImage.image =[UIImage imageNamed:@"slight right.png"];
    }
    else if([info.Arrow isEqualToString:@"Right"]){
        arrowImage.image =[UIImage imageNamed:@"right turn.png"];
    }
    else if([info.Arrow isEqualToString:@"slight left"]){
        arrowImage.image =[UIImage imageNamed:@"slight left.png"];
    }
    else if([info.Arrow isEqualToString:@"Left"]){
        arrowImage.image =[UIImage imageNamed:@"left turn.png"];
    }
    
    //Show Directional Image
    UIImage *temp = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: info.Picture]]];
    directionImage.image = temp;
    
    int rows = [allEvents count] - 1;
    if (currentEvent == rows)
        nextDirButton.hidden = YES;
    else
        nextDirButton.hidden = NO;
    if(currentEvent == 0)
        prevDirButton.hidden = YES;
    else if(currentEvent != 0)
        prevDirButton.hidden = NO;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
	
    if(self.context == nil)
        self.context = [[Get_Me_ThereAppDelegate sharedAppDelegate] managedObjectContext];
    
	NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1); 
    }
    NSArray *allEvents=[[[_fetchedResultsController sections] objectAtIndex:0] objects];
    Event *info=[allEvents objectAtIndex:currentEvent];

    
    //Show Arrow Image
    if([info.Arrow isEqualToString:@"straight"]){
        arrowImage.image =[UIImage imageNamed:@"straight.png"];
    }
    else if([info.Arrow isEqualToString:@"slight right"]){
        arrowImage.image =[UIImage imageNamed:@"slight right.png"];
    }
    else if([info.Arrow isEqualToString:@"Right"]){
        arrowImage.image =[UIImage imageNamed:@"right turn.png"];
    }
    else if([info.Arrow isEqualToString:@"slight left"]){
        arrowImage.image =[UIImage imageNamed:@"slight left.png"];
    }
    else if([info.Arrow isEqualToString:@"Left"]){
        arrowImage.image =[UIImage imageNamed:@"left turn.png"];
        
    }
    
    //Show Directional Image
    UIImage *temp = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: info.Picture]]];
    directionImage.image = temp;
    
    int rows = [allEvents count] - 1;
    if (currentEvent == rows)
        nextDirButton.hidden = YES;
    if(currentEvent == 0)
        prevDirButton.hidden = YES;
    

}

- (void)viewDidUnload
{
    //[super viewDidUnload];
    self.fetchedResultsController = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void) viewWillAppear:(BOOL)animated {
    [[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeLeft];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

@end
