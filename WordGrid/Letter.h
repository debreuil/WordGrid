//
//  Letter.h
//  WordGrid
//
//  Created by admin on 12-12-01.
//
//

#import <Foundation/Foundation.h>

@interface Letter : NSObject

@property (nonatomic, strong) NSString *letter;
@property (nonatomic) int gridX;
@property (nonatomic) int gridY;

- (id) initLetter:(NSString *)letter;
- (id) initLetter:(NSString *) letter atX: (int) x andY:(int)y;

@end
