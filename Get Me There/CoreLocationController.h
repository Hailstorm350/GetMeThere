//
//  CoreLocationController.h
//  Get Me There
//
//  Created by Kenneth Wigginton on 4/30/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol CoreLocationControllerDelegate
@required
- (void)locationUpdate:(CLLocation *)location; // Our location updates are sent here
- (void)locationError:(NSError *)error; // Any errors are sent here
@end

@interface CoreLocationController : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locMgr;
}

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, assign) id delegate;
@property int currentlyMonitoredEvent;

@end