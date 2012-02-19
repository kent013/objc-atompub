#import "AtomElement.h"
#import "AtomNamespace.h"

@implementation AtomElement

+ (NSString *)elementName {
  return @"element";
}

+ (DDXMLNode *)elementNamespace {
  return [ AtomNamespace atom ];
}

- (id)init {
  if ((self = [ super init ]) != nil) {
    element =
      [ [ DDXMLElement alloc ] initWithName:
        [ [ self class ] elementName ] ];
    [ element addNamespace:
      [ [ self class ] elementNamespace ] ];
  }
  return self;
}

- (id)initWithXMLElement:(DDXMLElement *)elem {
  if ((self = [ super init ]) != nil) {
    element = [ elem retain ];
  }
  return self;
}

- (id)initWithXMLString:(NSString *)string {
  if ((self = [ super init ]) != nil) {
    element =
      [ [ DDXMLElement alloc ] initWithXMLString:string
                                           error:nil ];
  }
  return self;
}

- (DDXMLDocument *)document {
  DDXMLDocument *doc = 
    [ [ [ DDXMLDocument alloc ] initWithRootElement: [ element copy ] ]
      autorelease ];
  return doc;
}

- (void)addElementWithNamespace:(DDXMLNode *)namespace
                    elementName:(NSString *)elementName
                          value:(NSString *)value {
  [ self addElementWithNamespace:namespace
                    elementName:elementName
                          value:value
                     attributes:nil];
}
- (void)addElementWithNamespace:(DDXMLNode *)namespace
                    elementName:(NSString *)elementName
                          value:(NSString *)value
                     attributes:(NSDictionary *)attributes {
  DDXMLElement *aElement =
    [ DDXMLElement elementWithName: elementName ];
  [ aElement addNamespace: namespace ];
  DDXMLNode *textNode = [ DDXMLNode textWithStringValue: value ];
  [ aElement addChild: textNode ];
  if (attributes != nil) {
    NSEnumerator *enumerator = [ attributes keyEnumerator ];
    NSString *attrKey, *attrValue;
    while ((attrKey = (NSString *)[enumerator nextObject]) != nil) {
      attrValue = (NSString *)[ attributes objectForKey:attrKey ];
      DDXMLNode *attr = [ DDXMLNode attributeWithName:attrKey
                                          stringValue:attrValue ];
      [ element addAttribute:attr ];
      [ attrKey release ];
    }
  }
  [ element addChild: aElement ];
}

- (void)addElementWithNamespace:(DDXMLNode *)namespace
                    elementName:(NSString *)elementName
                    atomElement:(AtomElement *)atomElement {
  [ self addElementWithNamespace:namespace
                     elementName:elementName
                         element:[ atomElement element ] ];
}
- (void)addElementWithNamespace:(DDXMLNode *)namespace
                    elementName:(NSString *)elementName
                        element:(DDXMLElement *)aElement {
  DDXMLElement *newElement =
    [ DDXMLElement elementWithName:elementName ];
  [ newElement addNamespace:namespace ];
  int i;
  int count = [ aElement childCount ];
  DDXMLNode *child;
  for (i = 0; i < count; i++) {
    child = [ aElement childAtIndex:i ];
    switch ([ child kind ]) {
      case DDXMLElementKind:
        [ newElement addChild:[ child copy ] ];
        break;
      case DDXMLTextKind:
        [ newElement addChild:
          [ DDXMLNode textWithStringValue:[ child stringValue ] ] ];
        break;
    }
  }
  NSArray *attributes = [ aElement attributes ];
  count = [ attributes count ];
  for (i = 0; i < count; i++) {
    [ newElement addAttribute:
      [ (DDXMLNode *)[ attributes objectAtIndex:i ] copy ] ];
  }
  [ element addChild:newElement ];
}

- (void)removeElementsWithNamespace:(DDXMLNode *)namespace
                        elementName:(NSString *)elementName {
  /*
  NSArray *elements =
    [ element elementsForLocalName:elementName
                               URI:[ namespace stringValue ]];
  if ([ elements count ] == 0)
    return;
  int i;
  int count = [ elements count ];
  for (i = 0; i < count; i++) {
    [ (DDXMLElement *)[ elements objectAtIndex:i ] detach ];
  }
  */
  int i = 0;
  while ( i < [ element childCount ] ) {
    DDXMLNode *child = [ element childAtIndex:i ];
    if ( [child kind ] == DDXMLElementKind
      && [ [ child localName ] isEqualToString:elementName ]
      && [ [ child URI ] isEqualToString:[ namespace stringValue ] ]) {
      [ element removeChildAtIndex:i ];
    } else {
      i++;
    }
  }
}

- (void)setElementWithNamespace:(DDXMLNode *)namespace
                    elementName:(NSString *)elementName
                          value:(NSString *)value {
  [ self removeElementsWithNamespace:namespace
                         elementName:elementName ];
  [ self addElementWithNamespace:namespace
                     elementName:elementName
                           value:value ];
}

- (void)setElementWithNamespace:(DDXMLNode *)namespace
                    elementName:(NSString *)elementName
                        element:(DDXMLElement *)aElement {
  [ self removeElementsWithNamespace:namespace
                         elementName:elementName ];
  [ self addElementWithNamespace:namespace
                     elementName:elementName
                         element:aElement ];
}

- (void)setElementWithNamespace:(DDXMLNode *)namespace
                    elementName:(NSString *)elementName
                    atomElement:(AtomElement *)atomElement {
  [ self removeElementsWithNamespace:namespace
                         elementName:elementName ];
  [ self addElementWithNamespace:namespace
                     elementName:elementName
                     atomElement:atomElement ];
}

- (DDXMLElement *)getElementWithNamespace:(DDXMLNode *)namespace
                              elementName:(NSString *)elementName {
  NSArray *elements =
    [ self getElementsWithNamespace:namespace 
                        elementName:elementName ];
  if ([ elements count ] > 0)
    return [ elements objectAtIndex:0 ];
  else
    return nil;
}

- (NSArray *)getElementsWithNamespace:(DDXMLNode *)namespace
                          elementName:(NSString *)elementName {
  NSArray *elements =
    [ element elementsForLocalName:elementName
                               URI:[ namespace stringValue ] ];
  return elements;
}

- (NSArray *)getElementsTextStringWithNamespace:(DDXMLNode *)namespace
                                    elementName:(NSString *)elementName {
  NSArray *elements =
    [ self getElementsWithNamespace:namespace
                        elementName:elementName ];
  int i;
  int count = [ elements count ];
  NSMutableArray *texts = [ NSMutableArray arrayWithCapacity:count ];
  for (i = 0; i < count; i++) {
    [ texts addObject: [ (DDXMLElement *)[ elements objectAtIndex:i ] stringValue ] ];
  }
  return texts;
}
- (NSString *)getElementTextStringWithNamespace:(DDXMLNode *)namespace
                                    elementName:(NSString *)elementName {
  DDXMLElement *elem =  [ self getElementWithNamespace:namespace
                                           elementName:elementName ];
  return (elem != nil) ? [ elem stringValue ] : nil;
}

- (NSString *)getAttributeValueForKey:(NSString *)key {
  DDXMLNode *attribute = [ element attributeForName:key ];
  return (attribute != nil) ? [ attribute stringValue ] : nil;
}

- (void)setAttributeValue:(NSString *)value
                 forKey:(NSString *)key {
  [ element addAttribute:
    [ DDXMLNode attributeWithName:key
                      stringValue:value ] ];
}

// @synthesize element;
- (DDXMLElement *)element {
  return [ [ element retain ] autorelease ];
}

- (void)dealloc {
  [ element release ];
  [ super dealloc ];
}

- (NSString *)stringValue {
  return [ [ NSString alloc ] initWithData:[ [ self document ] XMLData ]
                                  encoding:NSUTF8StringEncoding ];
}

- (NSArray *)getObjectsWithNamespace:(DDXMLNode *)namespace
                         elementName:(NSString *)elementName
                               class:(Class)class
                         initializer:(SEL)initializer {
  NSArray *list = [ self getElementsWithNamespace:namespace
                                      elementName:elementName ];
  int i;
  int count = [ list count ];
  NSMutableArray *filtered = [ NSMutableArray arrayWithCapacity:count ];
  for (i = 0; i < count; i++) {
    [ filtered addObject:[ class performSelector:initializer
                                      withObject:(DDXMLElement *)[ list objectAtIndex:i ] ] ];
  }
  return filtered;
}

- (id)getObjectWithNamespace:(DDXMLNode *)namespace
                 elementName:(NSString *)elementName
                       class:(Class)class
                 initializer:(SEL)initializer {
  DDXMLElement *elem = [ self getElementWithNamespace:namespace
                                          elementName:elementName ];
  return [ class performSelector:initializer
                      withObject:elem ];
}

@end

