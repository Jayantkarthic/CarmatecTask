// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>

@class MBNNRouteRefreshError;

/** Listener for routes refresh events */
NS_SWIFT_NAME(RouteRefreshObserver)
@protocol MBNNRouteRefreshObserver
/**
 * Will be called if route refresh succeeded
 * @param  id  internal identifier of the refresh request
 * @param  routeRefreshResponse  A string containing the json response from Directions Refresh API that represents refreshed route leg
 * @param  routeIndex  Index of the route in the original routes response
 * @param  legIndex  Index of the refreshed leg in the route with index routeIndex
 */
- (void)onRouteRefreshAnnotationsUpdatedForId:(uint64_t)id
                         routeRefreshResponse:(nonnull NSString *)routeRefreshResponse
                                   routeIndex:(uint32_t)routeIndex
                                     legIndex:(uint32_t)legIndex;
/**
 * Will be called in case route refresh was cancelled
 * @param  id  internal identifier of the refresh request
 */
- (void)onRouteRefreshCancelledForId:(uint64_t)id;
/**
 * Will be called in case route refresh was failed
 * @param  id  internal identifier of the refresh request
 * @param  error  details of the failure
 */
- (void)onRouteRefreshFailedForId:(uint64_t)id
                            error:(nonnull MBNNRouteRefreshError *)error;
@end
