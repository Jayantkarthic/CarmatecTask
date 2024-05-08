// This file is generated and will be overwritten automatically.

#import <Foundation/Foundation.h>
#import <MapboxNavigationNative/MBNNRefreshAlternativesCallback_Internal.h>

@class MBNNRouteAlternativesOptions;
@protocol MBNNRouteAlternativesObserver;

NS_SWIFT_NAME(RouteAlternativesControllerInterface)
@protocol MBNNRouteAlternativesControllerInterface
/**
 * Enables requesting alternate routes as soon as we pass a fork with an alternate route.
 *  Passed altrenal route will disappear from the list of alternative routes at any value.
 *  Enabled by default.
 */
- (void)enableRequestAfterForkForEnable:(BOOL)enable;
/**
 * Enables alternative routes periodic polling. Polling starts only if there are no alternatives.
 *  This will help avoid a situation when server has not returned any alternatives, but may return them later during the ride.
 *  Refreshes will be stopped if status.routeState is Invalid, OffRoute or Complete. And will be resumed otherwise.
 *  Now it can consume a lot of traffic!
 *  Disabled by default.
 */
- (void)enableOnEmptyAlternativesRequestForEnable:(BOOL)enable;
/** Set RouteAlternativesOptions (can be changed in run-time). */
- (void)setRouteAlternativesOptionsForOptions:(nonnull MBNNRouteAlternativesOptions *)options;
/** Add observer. Requests will not be sent if no one observer present. */
- (void)addObserverForObserver:(nonnull id<MBNNRouteAlternativesObserver>)observer;
/** Remove observer. Requests will not be sent if no one observer present. */
- (void)removeObserverForObserver:(nonnull id<MBNNRouteAlternativesObserver>)observer;
/** Remove all observers. Requests will not be sent if no one observer present. */
- (void)removeAllObservers;
/** Make alternative route request right now. */
- (void)refreshImmediately;
- (void)refreshImmediatelyForCallback:(nonnull MBNNRefreshAlternativesCallback)callback;
@end
