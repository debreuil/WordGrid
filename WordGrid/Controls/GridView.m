//
//  TileGridView.m
//  WordGrid
//
//  Created by admin on 12-12-01.
//
//

#import "Grid.h"
#import "GridView.h"
#import "TileView.h"
#import "Tile.h"

@interface GridView()
{
    UIView *blankView;
}
- (void)    createGrid;
@end

@implementation GridView

@synthesize grid = _grid;
@synthesize tileViews;

@synthesize margin;
@synthesize lastHoverTileIndex;
@synthesize tileWidth;
@synthesize tileHeight;
@synthesize slotWidth;
@synthesize slotHeight;
@synthesize animationDelay;
@synthesize isEmptyHidden;

UIInterfaceOrientation io;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.margin = 4;
        self.tileViews = [NSMutableArray arrayWithCapacity:200];
        blankView = [[UIView alloc] init];
        blankView.hidden = YES;
        [self addSubview:blankView];
    }
    return self;
}
- (void) setGrid:(Grid *)g
{
    [self clearGrid];
    _grid = g;
    [self createGrid];
}

- (void) clearGrid
{
    for(TileView *tv in self.tileViews)
    {
        [tv removeFromSuperview];
    }
    [self.tileViews removeAllObjects];
    _grid = nil;
}

- (void) createGrid
{           
    self.lastHoverTileIndex = -1;
    
    int gw = self.grid.gridSize.width;
    int gh = self.grid.gridSize.height;
    
    self.tileWidth = (self.bounds.size.width - self.margin * (gw - 2)) / gw;
    self.tileHeight = (self.bounds.size.height - self.margin * (gh - 2)) / gh;
    self.slotWidth = self.tileWidth + self.margin;
    self.slotHeight = self.tileHeight + self.margin;
    
    Tile *tile;
    TileView *tileView;
    
    CGRect r = CGRectMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0, self.tileWidth, self.tileHeight);
    for (int i = 0; i < gh; i++)
    {
        for (int j = 0; j < gw; j++)
        {
            tile = [self.grid getTileFromIndex:i * gw + j];            
            tileView = [[TileView alloc] initWithFrame:r andTile:tile];
            tileView.isEmptyHidden = self.isEmptyHidden;            
            [self.tileViews addObject:tileView];
            [self addSubview:tileView];
        }
    }
    
    [self layoutGrid:NO];
}

- (void) resetAnimationDelay:(int) delay
{
    self.animationDelay = delay;
}

- (void) layoutGrid:(Boolean) useAnimation
{
    [self resetAnimationDelay:0];
    //int gw = self.grid.gridSize.width;
    //int gh = self.grid.gridSize.height;
    
    [self bringSubviewToFront:blankView];
    UIView *topView = blankView;
            
    for(TileView * tv in self.tileViews)
    {    
        //NSLog(@"%@   %@", NSStringFromCGPoint(tv.tile.currentIndex), NSStringFromCGRect(tv.frame));
        
        if(tv.isSelected != tv.tile.isSelected ||
           tv.isSelectable != tv.tile.isSelectable ||
           tv.isHidden != tv.tile.isHidden)
        {
            tv.isSelected = tv.tile.isSelected;
            tv.isSelectable = tv.tile.isSelectable;
            tv.isHidden = tv.tile.isHidden;
            [tv setNeedsDisplay];
        }
        
        if(tv.currentIndex.x != tv.tile.currentIndex.x || tv.currentIndex.y != tv.tile.currentIndex.y)
        {
            //NSLog(@"v:%d,%d t:%d,%d",  (int)tv.currentIndex.x, (int)tv.currentIndex.y, (int)tv.tile.currentIndex.x, (int)tv.tile.currentIndex.y);
            tv.isHovering = NO;
            tv.currentIndex = tv.tile.currentIndex;
            
            [self insertSubview:tv belowSubview:topView];
            topView = tv;
            CGRect fr = CGRectMake(
                    self.margin / 2.0 + self.slotWidth * tv.tile.currentIndex.x,
                    self.margin / 2.0 + self.slotHeight * tv.tile.currentIndex.y,
                    self.tileWidth, self.tileHeight);            
            
            [UIView
             animateWithDuration:0.3 delay:self.animationDelay options: UIViewAnimationCurveEaseOut
             animations:^{ tv.frame = fr; }
             completion:^(BOOL finished){}
             ];
            
            self.animationDelay += .01;
        }
    }
    [self setNeedsDisplay];
}

- (Tile *) getTileFromMousePoint:(CGPoint) point
{
    Tile *result = nil;
    if(CGRectContainsPoint(self.bounds, point))
    {
        int tx = (int)(point.x / self.slotWidth);
        int ty = (int)(point.y / self.slotHeight);
        int tileIndex = ty * self.grid.gridSize.width + tx;
        result = [self.grid getTileFromIndex:tileIndex];
    }
    return result;
}

- (int) getTileIndexFromMousePoint:(CGPoint) point
{
    int tileIndex = -1;
    if(CGRectContainsPoint(self.bounds, point))
    {
        int tx = (int)(point.x / self.slotWidth);
        int ty = (int)(point.y / self.slotHeight);
        tileIndex = ty * self.grid.gridSize.width + tx;
        //Tile *t = [self.grid getTileFromIndex:tileIndex];
        if(tileIndex >= [self.tileViews count])// || [t isEmptyTile] || !t.isSelectable) // || t.selected
        {
            tileIndex = -1;
        }
    }
    return tileIndex;
}

-(void) hoverTileAtPoint:(CGPoint) p
{
    int tileIndex = [self getTileIndexFromMousePoint:p];
    if(tileIndex > -1)
    {
        if(tileIndex != self.lastHoverTileIndex && self.lastHoverTileIndex != -1)
        {
            [[self.tileViews objectAtIndex:self.lastHoverTileIndex] setIsHovering:(NO)];
        }
        TileView *t = [self.tileViews objectAtIndex:tileIndex];
        t.isHovering = YES;
        self.lastHoverTileIndex = tileIndex;
    }
    else
    {
        [self clearAllHovers];
    }
}

-(void) clearAllHovers
{
    for(TileView *t in self.tileViews)
    {
        t.isHovering = NO;
    }
    self.lastHoverTileIndex = -1;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *t = [touches anyObject];
    [self hoverTileAtPoint:[t locationInView:self]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *t = [touches anyObject];
    [self hoverTileAtPoint:[t locationInView:self]];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *t = [touches anyObject];
    Tile *tile = [self getTileFromMousePoint:[t locationInView:self]];

    if(tile.isSelectable)
    {
        //AudioServicesPlaySystemSound(tickSoundID);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"onTileSelected" object:tile];
    }
    [self clearAllHovers];      
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}


@end
