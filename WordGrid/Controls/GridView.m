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
- (void)    createGrid;
- (void)    layoutGrid:(Boolean) useAnimation;
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

UIInterfaceOrientation io;

-(id)init
{
    self = [super init];
    if(self)
    {
        self.tileViews = [NSMutableArray arrayWithCapacity:200];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.tileViews = [NSMutableArray arrayWithCapacity:200];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {        
        self.tileViews = [NSMutableArray arrayWithCapacity:200];
    }
    return self;
}

-(void) subviewDidAppear
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onSelectTile:)
     name:@"onTileSelected"
     object:nil];
}
-(void) subviewDidDisappear
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onTileSelected" object:nil];
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
    self.margin = 4;    
    self.lastHoverTileIndex = -1;
    
    int gw = self.grid.gridSize.width;
    int gh = self.grid.gridSize.height;
    
    self.tileWidth = (self.bounds.size.width - self.margin * (gw - 2)) / gw;
    self.tileHeight = (self.bounds.size.height - self.margin * (gh - 2)) / gh;
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
    int gw = self.grid.gridSize.width;
    int gh = self.grid.gridSize.height;
    
    float l = self.margin / 2.0 + (gw - 1) * self.slotWidth;
    float t = self.margin / 2.0 + (gh - 1) * self.slotHeight;
    
    CGRect fr = CGRectMake(l, t, self.tileWidth, self.tileHeight);
    TileView *tileView;
    
    for (int i = gh - 1; i >= 0; i--)
    {
        for (int j = gw - 1; j >= 0; j--)
        {
            tileView = [self.tileViews objectAtIndex: i * gw + j];
            //tileView.gridIndex = i * gw + j;
            if(!tileView.hidden)
            {
                if(useAnimation && !CGRectEqualToRect(fr, tileView.frame))
                {
                    if(!CGRectEqualToRect(tileView.animatingFrom, CGRectNull))
                    {
                        tileView.frame = tileView.animatingFrom;
                        tileView.animatingFrom = CGRectNull;
                    }
                    
                    tileView.animatingFrom = tileView.frame;
                    self.animationDelay += .01;
                    [UIView
                     animateWithDuration:0.3
                     delay:self.animationDelay
                     options: UIViewAnimationCurveEaseOut
                     animations:^
                     {
                         tileView.frame = fr;
                     }
                     completion:^(BOOL finished){tileView.animatingFrom = CGRectNull;}
                     ];
                }
                else
                {
                    tileView.frame = fr;
                }
            }
            fr.origin.x -= self.slotWidth;
        }
        fr.origin.x = l;
        fr.origin.y -= self.slotHeight;
    }
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


-(void) dropRemovedWord
{
    self.animationDelay = 0.3;
    [self layoutGrid:YES];
    self.animationDelay += 0.1;
    //[self removeVerticalGaps];
}

- (void) onSelectTile:(NSNotification *)notification
{
    Tile *tile = (Tile *)[notification object];    
    tile.isSelected = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onGridTileSelected" object:tile];
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"onTileSelected" object:self];
    }
    [self setNeedsDisplay];

    
    [self clearAllHovers];
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}


@end
