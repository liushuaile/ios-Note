//
//  CGContextObject.h



#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "RGBColor.h"
#import "GradientColor.h"
@class CGContextObject;


typedef void(^CGContextObjectDrawBlock_t)(CGContextObject *contextObject);

@interface CGContextObject : NSObject

/**
 *  操作句柄
 */
@property (nonatomic)          CGContextRef   context;

/**
 *  线头样式
 */
@property (nonatomic)          CGLineCap      lineCap;

/**
 *  线条宽度
 */
@property (nonatomic)          CGFloat        lineWidth;

/**
 *  线条颜色
 */
@property (nonatomic, strong)  RGBColor      *strokeColor;

/**
 *  填充颜色
 */
@property (nonatomic, strong)  RGBColor      *fillColor;

/**
 *  由context进行初始化
 *
 *  @param context 绘制句柄
 *
 *  @return 绘制对象
 */
- (instancetype)initWithCGContext:(CGContextRef)context;

#pragma mark - 绘制操作流程
/**
 *  开始path
 */
- (void)beginPath;

/**
 *  关闭path
 */
- (void)closePath;

/**
 *  线条绘制
 */
- (void)strokePath;

/**
 *  填充绘制
 */
- (void)fillPath;

/**
 *  线条绘制 + 填充绘制
 */
- (void)strokeAndFillPath;

/**
 *  绘制线条用block (beginPath + closePath + 你绘制的代码 + strokePath)
 *
 *  @param block 绘制用block
 */
- (void)drawStrokeBlock:(CGContextObjectDrawBlock_t)block;

/**
 *  填充区域用block (beginPath + closePath + 你绘制的代码 + fillPath)
 *
 *  @param block 填充用block
 */
- (void)drawFillBlock:(CGContextObjectDrawBlock_t)block;

/**
 *  绘制加填充
 *
 *  @param block 绘制加填充用block
 */
- (void)drawStrokeAndFillBlock:(CGContextObjectDrawBlock_t)block;

/**
 *  绘制线条用block (beginPath + closePath + 你绘制的代码 + strokePath)
 *
 *  @param block     绘制用block
 *  @param closePath 是否关闭曲线
 */
- (void)drawStrokeBlock:(CGContextObjectDrawBlock_t)block closePath:(BOOL)closePath;

/**
 *  填充区域用block (beginPath + closePath + 你绘制的代码 + fillPath)
 *
 *  @param block     绘制用block
 *  @param closePath 是否关闭曲线
 */
- (void)drawFillBlock:(CGContextObjectDrawBlock_t)block closePath:(BOOL)closePath;

/**
 *  绘制加填充
 *
 *  @param block     绘制用block
 *  @param closePath 是否关闭曲线
 */
- (void)drawStrokeAndFillBlock:(CGContextObjectDrawBlock_t)block closePath:(BOOL)closePath;

#pragma mark - 绘制图片API

- (void)drawImage:(UIImage *)image atPoint:(CGPoint)point;
- (void)drawImage:(UIImage *)image atPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
- (void)drawImage:(UIImage *)image inRect:(CGRect)rect;
- (void)drawImage:(UIImage *)image inRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
- (void)drawImage:(UIImage *)image asPatternInRect:(CGRect)rect;

#pragma mark - 保存操作

/**
 *  将当前设置存取到栈区中(入栈操作)
 */
- (void)saveStateToStack;

/**
 *  从栈区中取出之前保存的设置(出栈操作)
 */
- (void)restoreStateFromStack;

#pragma mark - 图形绘制API
/**
 *  移动到起始点
 *
 *  @param point 起始点
 */
- (void)moveToStartPoint:(CGPoint)point;

/**
 *  添加一个点(与上一个点直线相连)
 *
 *  @param point 点
 */
- (void)addLineToPoint:(CGPoint)point;

/**
 *  添加二次贝塞尔曲线
 *
 *  @param point    结束点
 *  @param pointOne 控制点1
 *  @param pointTwo 控制点2
 */
- (void)addCurveToPoint:(CGPoint)point controlPointOne:(CGPoint)pointOne controlPointTwo:(CGPoint)pointTwo;

/**
 *  添加一次贝塞尔曲线
 *
 *  @param point        结束点
 *  @param controlPoint 控制点
 */
- (void)addQuadCurveToPoint:(CGPoint)point controlPoint:(CGPoint)controlPoint;

/**
 *  在指定的区域填充彩色的矩形（此为直接绘制）
 *
 *  @param rect          指定的区域
 *  @param gradientColor 渐变色对象
 */
- (void)drawLinearGradientAtClipToRect:(CGRect)rect gradientColor:(GradientColor *)gradientColor;

#pragma mark - 
/**
 *  添加一个矩形
 *
 *  @param rect
 */
- (void)addRect:(CGRect)rect;

/**
 *  在给定的矩形中绘制椭圆
 *
 *  @param rect
 */
- (void)addEllipseInRect:(CGRect)rect;

/**
 *  将string绘制在指定的点上
 *
 *  @param string     字符串
 *  @param point      点
 *  @param attributes 富文本设置（可以为空）
 */
- (void)drawString:(NSString *)string atPoint:(CGPoint)point withAttributes:(NSDictionary *)attributes;

/**
 *  将string绘制在制定的区域
 *
 *  @param string     字符串
 *  @param rect       区域
 *  @param attributes 富文本设置（可以为空）
 */
- (void)drawString:(NSString *)string inRect:(CGRect)rect withAttributes:(NSDictionary *)attributes;

/**
 *  将富文本绘制在制定的点上
 *
 *  @param string 富文本
 *  @param point  点
 */
- (void)drawAttributedString:(NSAttributedString *)string atPoint:(CGPoint)point;

/**
 *  将富文本绘制在制定的矩形中
 *
 *  @param string 富文本
 *  @param rect   矩形
 */
- (void)drawAttributedString:(NSAttributedString *)string inRect:(CGRect)rect;

@end
