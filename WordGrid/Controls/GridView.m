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
#import "Round.h"
#import "GridOverlay.h"

extern SystemSoundID tickSoundID;

@interface GridView()
{
    GridOverlay *blankView;
    int yOffset;
    BOOL ignoreDrag;
}

- (void) createGrid;

@end

@implementation GridView

UIInterfaceOrientation io;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.margin = 4;
        self.tileViews = [NSMutableArray arrayWithCapacity:200];
        blankView = [[GridOverlay alloc] init];
        blankView.opaque = NO;
        blankView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:blankView];
        
        //self.clipsToBounds = YES;
        ignoreDrag = NO;        
        
        //self.backgroundColor = [UIColor colorWithRed:0.5 green:0 blue:0 alpha:0.5];
        //blankView.backgroundColor = [UIColor colorWithRed:0.0 green:0.9 blue:0 alpha:0.5];
    }
    return self;
}

- (void) setRound:(Round *)rnd
{
    [self clearGrid];
    _round = rnd;
    _grid = _round.grid;
    blankView.gridView = self;
    [self createGrid];
}

- (void) setGrid:(Grid *)grd
{
    [self clearGrid];
    _grid = grd;
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
    int maxH = (_maxRows == 0) ? self.grid.gridSize.height : _maxRows;
    yOffset = (_maxRows == 0) ? 0 : _maxRows - gh;
    
    self.tileWidth = (self.bounds.size.width - self.margin * (gw - 1)) / gw;
    self.tileHeight = (self.bounds.size.height - self.margin * (maxH - 1)) / maxH;
    self.slotWidth = self.tileWidth + self.margin;
    self.slotHeight = self.tileHeight + self.margin;
    
    Tile *tile;
    TileView *tileView;
    
    CGRect r = CGRectMake(0, 0, self.tileWidth, self.tileHeight);
    for (int i = 0; i < gh; i++)
    {
        for (int j = 0; j < gw; j++)
        {
            tile = [self.grid getTileFromIndex:i * gw + j];            
            tileView = [[TileView alloc] initWithFrame:r andTile:tile];
            //tileView.isOffScreen = [self isOffScreen:tileView.tile];

            [self.tileViews addObject:tileView];
            [self addSubview:tileView];
        }
    }
    
    [self layoutGrid:NO];
    
    //r = self.frame;
    //self.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, r.size.height - tileHeight);
}

- (void) resetAnimationDelay:(int) delay
{
    self.animationDelay = delay;
}
- (void)bringSubviewToFront:(UIView *)view
{
    [super bringSubviewToFront:view];
    [super bringSubviewToFront:blankView];
}
- (BOOL) isOffScreen:(Tile*)tile
{
    return tile.currentIndex.y >= 0 &&
            tile.currentIndex.y + yOffset < 0;
}
- (void) layoutGrid:(Boolean) useAnimation
{
    [self resetAnimationDelay:0];
    
    [self bringSubviewToFront:blankView];
    UIView *topView = blankView;
        
    for(TileView * tv in self.tileViews)
    {    
        //NSLog(@"%@   %@", NSStringFromCGPoint(tv.tile.currentIndex), NSStringFromCGRect(tv.frame));
        
        if(tv.tile == (id)[NSNull null]) continue;
        
        if(tv.isSelected != tv.tile.isSelected ||
           tv.isSelectable != tv.tile.isSelectable ||
           tv.isHidden != tv.tile.isHidden)
        {
            tv.isSelected = tv.tile.isSelected;
            tv.isSelectable = tv.tile.isSelectable;
            tv.isHidden = tv.tile.isHidden;
            [tv setNeedsDisplay];
        }
        
        if(tv.isOffScreen != [self isOffScreen:tv.tile])
        {
           tv.isOffScreen = [self isOffScreen:tv.tile];
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
                    self.slotWidth * tv.tile.currentIndex.x,
                    self.slotHeight * (tv.tile.currentIndex.y + yOffset),
                    self.tileWidth, self.tileHeight);            
            
            [UIView
             animateWithDuration:0.3 delay:self.animationDelay options: UIViewAnimationOptionCurveEaseOut
             animations:^{ tv.frame = fr; }
             completion:^(BOOL finished){}
             ];
            
            self.animationDelay += .01;
            [tv setNeedsDisplay];
        }
    }
    
    [self setNeedsDisplay];
    [blankView setNeedsDisplay];
}

- (CGPoint)  getCenterFromTile:(Tile *) tile
{
    IntPoint pt = tile.currentIndex;
    return CGPointMake(self.slotWidth * pt.x + self.tileWidth / 2.0,
                       self.slotHeight * (pt.y + yOffset) + self.tileHeight / 2.0);
}

- (Tile *) getTileFromMousePoint:(CGPoint) point centerOnly:(BOOL) centerOnly
{
    Tile *result = nil;
    if(CGRectContainsPoint(self.bounds, point))
    {
        int tileIndex = [self getTileIndexFromMousePoint:point centerOnly:NO];
        result = [self.grid getTileFromIndex:tileIndex];
    }
    return result;
}

- (int) getTileIndexFromMousePoint:(CGPoint) point centerOnly:(BOOL) centerOnly
{
    int tileIndex = -1;
    if(CGRectContainsPoint(self.bounds, point))
    {
        int tx = (int)(point.x / self.slotWidth);
        int ty = (int)(point.y / self.slotHeight);
        tileIndex = tx + (ty - yOffset) * self.grid.gridSize.width;

        if(tileIndex >= [self.tileViews count])
        {
            tileIndex = -1;
        }
        else if(centerOnly)
        {
            CGPoint tCent = CGPointMake(tx * self.slotWidth + self.slotWidth / 2.0 - self.margin,
                                        ty * self.slotHeight + self.slotHeight / 2.0 - self.margin);
            float difX = tCent.x - point.x;
            float difY = tCent.y - point.y;
            float dist = difX * difX + difY * difY;
            
            if(dist > (self.slotWidth / 2.7) * (self.slotWidth / 2.7))
            {
                tileIndex = -1;
            }
            else
            {
                //NSLog(@"x: %d y:%d index:%d", tx, ty, tileIndex);
            }
        }
    }
    return tileIndex;
}

-(int) hoverTileAtPoint:(CGPoint) p centerOnly:(BOOL) centerOnly
{
    int tileIndex = [self getTileIndexFromMousePoint:p centerOnly:centerOnly];
    if(tileIndex > -1)
    {
        if(tileIndex != self.lastHoverTileIndex && self.lastHoverTileIndex != -1)
        {
            [[self.tileViews objectAtIndex:self.lastHoverTileIndex] setIsHovering:(NO)];
        }
        TileView *t = [self.tileViews objectAtIndex:tileIndex];
        if(t.tile != (id)[NSNull null])
        {
            t.isHovering = YES;
            self.lastHoverTileIndex = tileIndex;
        }
    }
    else
    {
        [self clearAllHovers];
    }
    return tileIndex;
}

-(void) clearAllHovers
{
    for(TileView *t in self.tileViews)
    {
        if(t.tile == (id)[NSNull null]) continue;
        
        t.isHovering = NO;
    }
    self.lastHoverTileIndex = -1;
}

- (void) finishMultiTileDrag
{
    ignoreDrag = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    ignoreDrag = NO;
    
    UITouch *t = [touches anyObject];
    [self hoverTileAtPoint:[t locationInView:self] centerOnly:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!ignoreDrag)
    {
        [super touchesMoved:touches withEvent:event];
        
        [self selectTileFromTouch:touches centerOnly:YES];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if(!ignoreDrag)
    {
        [self selectTileFromTouch:touches centerOnly:NO];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onCheckWord" object:nil];
    ignoreDrag = NO;
}

- (void) selectTileFromTouch:(NSSet *)touches centerOnly:(BOOL)centerOnly
{    
    UITouch *t = [touches anyObject];
    int tileIndex = [self hoverTileAtPoint:[t locationInView:self] centerOnly:centerOnly];
    Tile *tile = [self.grid getTileFromIndex:tileIndex];
    
    if(tile && tile != (id)[NSNull null] && tile.isSelectable)
    {
        AudioServicesPlaySystemSound(tickSoundID);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"onTileSelected" object:tile];
    }
    [self clearAllHovers];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}


@end
