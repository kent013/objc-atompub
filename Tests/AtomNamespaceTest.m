#import "AtomNamespaceTest.h"
#import "AtomNamespace.h"

@implementation AtomNamespaceTest

- (void)testAtom {
  DDXMLNode *ns = [ AtomNamespace atom ];
  STAssertTrue( [ [ ns name ] isEqualToString: @"" ], nil );
  STAssertTrue( [ [ ns stringValue ] isEqualToString:@"http://www.w3.org/2005/Atom" ], nil );
}

- (void)testAtomWithPrefix {
  DDXMLNode *ns = [ AtomNamespace atomWithPrefix ];
  STAssertTrue( [ [ ns name ] isEqualToString: @"atom" ], nil );
  STAssertTrue( [ [ ns stringValue ] isEqualToString: @"http://www.w3.org/2005/Atom" ], nil );
}

- (void)testApp {
  DDXMLNode *ns = [ AtomNamespace app ];
  STAssertTrue( [ [ ns name ] isEqualToString: @"" ], nil );
  STAssertTrue( [ [ ns stringValue ] isEqualToString: @"http://www.w3.org/2007/app" ], nil );
}

- (void)testAppWithPrefix {
  DDXMLNode *ns = [ AtomNamespace appWithPrefix ];
  STAssertTrue( [ [ ns name ] isEqualToString: @"app" ], nil );
  STAssertTrue( [ [ ns stringValue ] isEqualToString: @"http://www.w3.org/2007/app" ], nil );
}

- (void)testOpenSearch {
  DDXMLNode *ns = [ AtomNamespace openSearch ];
  STAssertTrue( [ [ ns name ] isEqualToString: @"openSearch" ], nil );
  STAssertTrue( [ [ ns stringValue ] isEqualToString: @"http://a9.com/-/spec/opensearchrss/1.1/" ], nil );
}

- (void)testThreading {
  DDXMLNode *ns = [ AtomNamespace threading ];
  STAssertTrue( [ [ ns name ] isEqualToString: @"thr" ], nil );
  STAssertTrue( [ [ ns stringValue ] isEqualToString: @"http://purl.org/syndication/thread/1.0" ], nil );
}

@end
