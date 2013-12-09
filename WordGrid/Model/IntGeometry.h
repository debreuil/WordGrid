
typedef struct
{
    NSInteger x;
    NSInteger y;
} IntPoint;

CG_INLINE IntPoint IntPointMake(NSInteger x, NSInteger y)
{
    IntPoint p; p.x = x; p.y = y; return p;
}

CG_INLINE bool __IntPointEqualToPoint(IntPoint p1, IntPoint p2)
{
    return p1.x == p2.x && p1.y == p2.y;
}
#define IntPointEqualToPoint __IntPointEqualToPoint


typedef struct
{
    NSInteger width;
    NSInteger height;
} IntSize;

CG_INLINE IntSize IntSizeMake(NSInteger w, NSInteger h)
{
    IntSize s; s.width = w; s.height = h; return s;
}

CG_INLINE bool __IntSizeEqualToSize(IntSize s1, IntSize s2)
{
    return s1.width == s2.width && s1.height == s2.height;
}
#define IntSizeEqualToSize __IntSizeEqualToSize