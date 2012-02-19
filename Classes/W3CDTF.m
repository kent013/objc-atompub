#import "W3CDTF.h"
#import "ISO8601DateFormatter.h"

@implementation W3CDTF

+ (NSDate *)dateFromString:(NSString *)formattedDate {
    ISO8601DateFormatter *formatter = [[ISO8601DateFormatter alloc] init];
    return [formatter dateFromString:formattedDate];
}

+ (NSString *)stringFromDate:(NSDate *)date {
    time_t clock = [date timeIntervalSince1970];

    char str[255];
    strftime(str, sizeof(str), "%Y-%m-%dT%H:%M:%SZ", gmtime(&clock));

    return [NSString stringWithUTF8String: str];
}

@end

