//
//  UIButton+Extension.m


#import "UIButton+Extension.h"
#import "UIView+Frame.h"

@implementation UIButton (Extension)

+ (instancetype)buttonWithTitle:(NSString *)title titleFont:(CGFloat)size titleColor:(UIColor *)color target:(id)target action:(SEL)method
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:size];
    [btn addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

+ (instancetype)buttonWithNormalImage:(NSString *)image selectImage:(NSString *)selImage imageType:(ButtonImageType)imageType target:(id)target action:(SEL)method
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn configButtonNormalImage:image selectImage:selImage imageType:imageType];
    [btn addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)configButtonNormalImage:(NSString *)image selectImage:(NSString *)selImage imageType:(ButtonImageType)imageType
{
    if (imageType == btnImgTypeSmall)
    {
        [self setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        if (selImage) {
            [self setImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
        }
    } else
    {
        [self setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
        if (selImage) {
            [self setBackgroundImage:[UIImage imageNamed:selImage] forState:UIControlStateSelected];
        }
    }
}
- (void)configButtonTitleColor:(UIColor *)color selectTitleColor:(UIColor *)selColor backgroundColor:(UIColor *)bgColor
{
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:selColor forState:UIControlStateSelected];
    [self setBackgroundColor:bgColor];
}

- (void)configButtonTitle:(NSString *)title fontSize:(CGFloat)size titleColor:(UIColor *)color
{
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:size];
    [self setTitleColor:color forState:UIControlStateNormal];
}


+ (UIButton *)buttonWithImageWithTitleWithFrame:(CGRect)frame
                                       butStyle:(BtnStyle)butStyle
                                          title:(NSString *)title
                                      titleFont:(CGFloat)titleFont
                                     titleColor:(UIColor *)titleColor
                                  textAlignment:(NSTextAlignment)textAlignment
                                       imageStr:(NSString *)imageStr
                               placeholderImage:(NSString *)placeholderImage
                                      imageSize:(CGSize)imageSize
                                      useRadius:(BOOL)useRadius
                                         target:(id)target
                                         action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageView = [[UIImageView alloc] init];
    if (butStyle == LeftRight || butStyle == RightLeft){
        
        CGFloat imageY = (frame.size.height-imageSize.height)/2;
        CGFloat imageX = (butStyle == LeftRight) ? 0 : (frame.size.width - imageSize.width);
        imageView.frame = CGRectMake( imageX,  imageY,  imageSize.width,  imageSize.height);
    }else{
        CGFloat imageX = (frame.size.width-imageSize.width)/2;
        CGFloat imageY = (butStyle == TopBottom) ? 0 : (frame.size.height - imageSize.height);
        imageView.frame = CGRectMake(imageX, imageY,  imageSize.width,  imageSize.height);
    }
    if ([imageStr hasPrefix:@"http"]){
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"0"]];

    }else{
        imageView.image = [UIImage imageNamed:imageStr];
    }
    
    if (useRadius) {
        imageView.layer.cornerRadius = imageSize.width/2;
        imageView.clipsToBounds = YES;
    }
    [button addSubview:imageView];
    
    UILabel *label = [UILabel labelWithText:title
                                   fontSize:titleFont
                                  textColor:titleColor
                                  alignment:textAlignment];
    
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:titleFont]}];
    
    if (butStyle == LeftRight || butStyle == RightLeft){
        CGFloat newWidth = titleSize.width >= (frame.size.width-imageSize.width) ? frame.size.width-imageSize.width : titleSize.width;
        CGFloat labelY = (frame.size.height-titleSize.height)/2;
        CGFloat labelX = (butStyle == LeftRight) ? (frame.size.width - newWidth) : 0 ;
        label.frame = CGRectMake(labelX,  labelY, newWidth, titleSize.height);
    }else{
        CGFloat newWidth = titleSize.width <= (frame.size.width) ? frame.size.width : titleSize.width;
        CGFloat labelX = (frame.size.width-newWidth)/2;
        CGFloat labelY = (butStyle == TopBottom) ? (frame.size.height - titleSize.height) : 0;
        label.frame = CGRectMake(labelX, labelY, newWidth, titleSize.height);
    }
    [button addSubview:label];
    
    return button;
}


@end
