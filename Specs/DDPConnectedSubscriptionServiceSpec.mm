#import "DDPConnectedSubscriptionService.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(DDPConnectedSubscriptionServiceSpec)

describe(@"DDPConnectedSubscriptionService", ^{
    __block DDPConnectedSubscriptionService *service;
    __block ObjectiveDDP<CedarDouble> *ddp;

    beforeEach(^{
        ddp = nice_fake_for([ObjectiveDDP class]);
        service = [[DDPConnectedSubscriptionService alloc] init];
    });
    
    describe(@"-makeSubscriptionsWithDDP:subscriptions:", ^{
        __block NSArray *subscriptions;
        
        beforeEach(^{
            subscriptions = @[@{@"name": @"stuff", @"uid": @"1234"},
  @{@"name": @"other-stuff", @"uid": @"4321", @"params": @[]}];
            [service makeSubscriptionsWithDDP:ddp subscriptions:subscriptions];
        });
        
        it(@"should use ddp to send subscribe requests", ^{
            ddp should have_received(@selector(subscribeWith:name:parameters:)).with(@"1234", @"stuff", nil);
            ddp should have_received(@selector(subscribeWith:name:parameters:)).with(@"4321", @"other-stuff", @[]);
        });
    });
});

SPEC_END