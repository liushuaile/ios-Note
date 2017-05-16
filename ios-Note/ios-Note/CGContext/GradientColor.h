//
//  GradientColor.h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GradientColor : NSObject

/**
 *  渐变色对象
 */
@property (nonatomic) CGGradientRef   gradientRef;

#pragma mark - 绘制位置相关
/**
 *  渐变色绘制起始点
 */
@property (nonatomic) CGPoint  gradientStartPoint;

/**
 *  渐变色绘制结束点
 */
@property (nonatomic) CGPoint  gradientEndPoint;

/**
 *  == 重写指定的方法改变颜色 ==
 *
 *  渐变色绘制结束点
 */
- (void)createColor;


+ (instancetype)createColorWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end
