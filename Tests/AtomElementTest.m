#import "AtomElementTest.h"
#import "AtomElement.h"
#import "AtomNamespace.h"

@implementation AtomElementTest

- (void)testBuild {
  AtomElement *elem = [ [ AtomElement alloc ] init ];
  NSString *result = [ elem stringValue ];
  STAssertEqualObjects( result, @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<element xmlns=\"http://www.w3.org/2005/Atom\"></element>", nil );
}

- (void)testAddingElement {
  AtomElement *elem = [ [ AtomElement alloc ] init ];
  [ elem addElementWithNamespace:[ AtomNamespace atom ]
                     elementName:@"title"
                           value:@"foobar" ];
  NSString *result = [ elem stringValue ];
  STAssertEqualObjects( result, @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<element xmlns=\"http://www.w3.org/2005/Atom\"><title xmlns=\"http://www.w3.org/2005/Atom\">foobar</title></element>", nil );
}

- (void)testAddingMultipleElement {
  AtomElement *elem = [ [ AtomElement alloc ] init ];
  [ elem addElementWithNamespace:[ AtomNamespace atom ]
                     elementName:@"title"
                           value:@"foobar" ];
  [ elem addElementWithNamespace:[ AtomNamespace atom ]
                     elementName:@"title"
                           value:@"barbuz" ];
  NSString *result = [ elem stringValue ];
  STAssertEqualObjects( result, @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<element xmlns=\"http://www.w3.org/2005/Atom\"><title xmlns=\"http://www.w3.org/2005/Atom\">foobar</title><title xmlns=\"http://www.w3.org/2005/Atom\">barbuz</title></element>", nil );
}

- (void)testAddingElementWithAttributes {
  AtomElement *elem = [ [ AtomElement alloc ] init ];
  NSMutableDictionary *attrs = [ NSMutableDictionary dictionary ];
  [ attrs setObject:@"foofoo" forKey:@"foo" ];
  [ attrs setObject:@"barbar" forKey:@"bar" ];
  [ elem addElementWithNamespace:[ AtomNamespace atom ]
                     elementName:@"title"
                           value:@"foobar"
                      attributes:attrs ];
  NSString *result = [ elem stringValue ];
  STAssertEqualObjects( result, @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<element xmlns=\"http://www.w3.org/2005/Atom\" foo=\"foofoo\" bar=\"barbar\"><title xmlns=\"http://www.w3.org/2005/Atom\">foobar</title></element>", nil );
}

- (void)testAddingDDXMLElement {
  AtomElement *elem = [ [ AtomElement alloc ] init ];
  DDXMLElement *newElement = [ DDXMLElement elementWithName:@"foo" ];
  [ newElement addChild:[ DDXMLNode textWithStringValue:@"barbuz" ] ];
  [ elem addElementWithNamespace:[ AtomNamespace atom ]
                     elementName:@"foo"
                         element:newElement ];
  NSString *result = [ elem stringValue ];
  STAssertEqualObjects( result, @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<element xmlns=\"http://www.w3.org/2005/Atom\"><foo xmlns=\"http://www.w3.org/2005/Atom\">barbuz</foo></element>", nil );
}

- (void)testAddingComplexDDXMLElement {
  AtomElement *elem = [ [ AtomElement alloc ] init ];
  DDXMLElement *newElement = [ DDXMLElement elementWithName:@"foo" ];
  DDXMLElement *newChild = [ DDXMLElement elementWithName:@"bar" ];
  [ newChild addChild:[ DDXMLNode textWithStringValue:@"buz" ] ];
  [ newChild addAttribute:
    [ DDXMLNode attributeWithName:@"uge"
                      stringValue:@"uga" ] ];
  [ newElement addChild:newChild ];
  [ newElement addAttribute:
    [ DDXMLNode attributeWithName:@"hoge"
                      stringValue:@"huga"] ];
  [ elem addElementWithNamespace:[ AtomNamespace atom ]
                     elementName:@"foo"
                         element:newElement];
  NSString *result = [ elem stringValue ];
  STAssertEqualObjects( result, @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<element xmlns=\"http://www.w3.org/2005/Atom\"><foo xmlns=\"http://www.w3.org/2005/Atom\" hoge=\"huga\"><bar uge=\"uga\">buz</bar></foo></element>", nil );
}

- (void)testRemovingElement {
  AtomElement *elem = [ [ AtomElement alloc ] init ];
  [ elem addElementWithNamespace:[ AtomNamespace atom ]
                     elementName:@"title"
                           value:@"foobar" ];
  [ elem removeElementsWithNamespace:[ AtomNamespace atom ]
                         elementName:@"title" ];
  NSString *result = [ elem stringValue ];
  STAssertEqualObjects( result, @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<element xmlns=\"http://www.w3.org/2005/Atom\"></element>", nil );
}

- (void)testSettingElement {
  AtomElement *elem = [ [ AtomElement alloc ] init ];
  [ elem addElementWithNamespace:[ AtomNamespace atom ]
                     elementName:@"title"
                           value:@"foobar" ];
  [ elem setElementWithNamespace:[ AtomNamespace atom ]
                     elementName:@"title"
                           value:@"barbuz" ];
  NSString *result = [ elem stringValue ];
  STAssertEqualObjects( result, @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<element xmlns=\"http://www.w3.org/2005/Atom\"><title xmlns=\"http://www.w3.org/2005/Atom\">barbuz</title></element>", nil );
}

- (void)testGettingElements {
  AtomElement *elem = [ [ AtomElement alloc ] init ];
  [ elem addElementWithNamespace:[ AtomNamespace atom ]
                     elementName:@"title"
                           value:@"foobar" ];
  [ elem addElementWithNamespace:[ AtomNamespace atom ]
                     elementName:@"title"
                           value:@"barbuz" ];
  NSArray *results =
    [ elem getElementsWithNamespace: [ AtomNamespace atom ]
                        elementName: @"title" ];
  STAssertEquals((float)[ results count ], 2.0f, nil );
  DDXMLElement *first = [ results objectAtIndex:0 ];
  STAssertEqualObjects( [ first stringValue ], @"foobar", nil );
  DDXMLElement *second = [ results objectAtIndex:1 ];
  STAssertEqualObjects( [ second stringValue ], @"barbuz", nil );
}

- (void)testGettingElement {
  AtomElement *elem = [ [ AtomElement alloc ] init ];
  [ elem addElementWithNamespace:[ AtomNamespace atom ]
                     elementName:@"title"
                           value:@"foobar" ];
  [ elem addElementWithNamespace:[ AtomNamespace atom ]
                     elementName:@"title"
                           value:@"barbuz" ];
  DDXMLElement *first =
    [ elem getElementWithNamespace: [ AtomNamespace atom ]
                       elementName: @"title" ];
  STAssertEqualObjects( [ first stringValue ], @"foobar", nil );
}

- (void)testSettingAttribute {
  AtomElement *elem = [ [ AtomElement alloc ] init ];
  [ elem setAttributeValue:@"bar" forKey:@"foo" ];
  NSString *result = [ elem stringValue ];
  STAssertEqualObjects( result, @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<element xmlns=\"http://www.w3.org/2005/Atom\" foo=\"bar\"></element>", nil );
}

- (void)testGettingAttribute {
  AtomElement *elem = [ [ AtomElement alloc ] init ];
  [ elem setAttributeValue:@"bar" forKey:@"foo" ];
  NSString *bar = [ elem getAttributeValueForKey:@"foo" ];
  STAssertEqualObjects( bar, @"bar", nil );
  NSString *unknown = [ elem getAttributeValueForKey:@"unknown" ];
  STAssertNil(unknown, nil );
}

- (void)testParsingElement {
  NSString *elementString = @"<element xmlns=\"http://www.w3.org/2005/Atom\" xmlns:app=\"http://www.w3.org/2007/app\"><title>hoge</title><app:control><app:draft>yes</app:draft></app:control></element>";
  NSError *error;
  DDXMLElement *xmlElem = [ [ DDXMLElement alloc ] initWithXMLString:elementString
                                                               error:&error ];
  //STAssertEqualObjects([error localizedDescription], @"", nil);
  AtomElement *elem = [ [ AtomElement alloc ] initWithXMLElement:xmlElem ];
  STAssertNotNil([ elem element ], nil);
  //NSString *elemResult = [ elem stringValue ];
  //STAssertEqualObjects( elemResult, @"", nil );
  DDXMLElement *title = [ elem getElementWithNamespace: [ AtomNamespace atom ]
                                           elementName:@"title" ];
  STAssertNotNil(title, nil);
  DDXMLElement *control = [ elem getElementWithNamespace: [ AtomNamespace app ]
                                           elementName:@"control" ];
  STAssertNotNil(control, nil);
  NSString *result = [ title stringValue ];
  STAssertEqualObjects( result, @"hoge", nil );
  NSString *result2 = [ control stringValue ];
  STAssertEqualObjects( result2, @"yes", nil );
}

@end

