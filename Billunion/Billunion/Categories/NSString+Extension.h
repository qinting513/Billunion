//
//  NSString+Verify.h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

/**验证是不是QQ号码*/
- (BOOL) isQQ;

/**验证是不是手机号码*/
- (BOOL) isPhone;

/**验证是不是邮箱*/
- (BOOL) isEmail;

/**
 *  根据字符串限定宽度和字体大小来返回高度
 *
 *  @param width 限定宽度
 *  @param size  字体大小
 *
 *  @return 高度
 */
- (CGFloat)getHeightWithLimitWidth:(CGFloat)width fontSize:(CGFloat)size;

/**
 *  根据字符串限定高度和字体大小来返回宽度
 *
 *  @param Height 限定高度
 *  @param size   字体大小
 *
 *  @return 宽度
 */
- (CGFloat)getWidthWithLimitHeight:(CGFloat)Height fontSize:(CGFloat)size;

/**
 *  返回字符串占用的尺寸
 *
 *  @param font    要计算文字的字体
 *  @param maxSize 文字的最大尺寸
 *
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

//判断字符串是否为浮点数
- (BOOL)isPureFloat;
//判断是否为整形：
- (BOOL)isPureInt;

//金额大写转换
+(NSString *)toCapitalLetters:(NSString *)money;

@end
