#import "AtomNamespace.h"

@implementation AtomNamespace
+ (DDXMLNode *)atom {
  return [DDXMLNode namespaceWithName:@""
                          stringValue:@"http://www.w3.org/2005/Atom"];
}
+ (DDXMLNode *)atomWithPrefix {
  return [DDXMLNode namespaceWithName:@"atom"
                          stringValue:@"http://www.w3.org/2005/Atom"];
}
+ (DDXMLNode *)app {
  return [DDXMLNode namespaceWithName:@""
                          stringValue:@"http://www.w3.org/2007/app"];
}
+ (DDXMLNode *)appWithPrefix {
  return [DDXMLNode namespaceWithName:@"app"
                          stringValue:@"http://www.w3.org/2007/app"];
}
+ (DDXMLNode *)openSearch {
  return [DDXMLNode namespaceWithName:@"openSearch"
                          stringValue:@"http://a9.com/-/spec/opensearchrss/1.1/"];
}
+ (DDXMLNode *)threading {
  return [DDXMLNode namespaceWithName:@"thr"
                          stringValue:@"http://purl.org/syndication/thread/1.0"];
}
@end

