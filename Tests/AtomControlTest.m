#import "AtomControlTest.h"
#import "AtomControl.h"
#import "AtomNamespace.h"

@implementation AtomControlTest
- (void)testElement {
  AtomControl *control = [ [ AtomControl alloc ] init ];
  NSString *controlString = [ control stringValue ];
  STAssertEqualObjects( controlString, @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<control xmlns=\"http://www.w3.org/2007/app\"></control>", nil );
}
- (void)testParams {
  AtomControl *control = [ [ AtomControl alloc ] init ];
  [ control setDraft:YES ];
  NSString *controlString = [ control stringValue ];
  STAssertEqualObjects( controlString, @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<control xmlns=\"http://www.w3.org/2007/app\"><draft xmlns=\"http://www.w3.org/2007/app\">yes</draft></control>", nil );
  BOOL isDraft = [ control draft ];
  STAssertTrue(isDraft, nil);
}
- (void)testInsertion {
  AtomElement *elem = [ [ AtomElement alloc ] init ];
  AtomControl *control = [ [ AtomControl alloc ] init ];
  [ control setDraft:YES ];
  [ elem addElementWithNamespace:[ AtomNamespace app ]
                     elementName:@"control"
                     atomElement:control ];
  NSString *result = [ elem stringValue ];
  STAssertEqualObjects( result, @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<element xmlns=\"http://www.w3.org/2005/Atom\"><control xmlns=\"http://www.w3.org/2007/app\"><draft xmlns=\"http://www.w3.org/2007/app\">yes</draft></control></element>", nil );
}
@end
