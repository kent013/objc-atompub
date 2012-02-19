#import <SenTestingKit/SenTestingKit.h>
#import "AtompubClientDelegate.h"

@class AtompubClient;

@interface AtompubClientTest : SenTestCase<AtompubClientDelegate> {
  AtompubClient *client;
}
@end

