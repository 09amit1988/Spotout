
#import <MapKit/MapKit.h>
#import <MapKit/MKAnnotation.h>

@interface MKMapView (Zoom)

-(void)zoomToFitAnnotations;

-(void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate zoomLevel:(NSUInteger)zoomLevel animated:(BOOL)animated;

@end
