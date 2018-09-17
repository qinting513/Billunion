//
//  NSString+Extension.m


#import "NSString+Extension.h"

@implementation NSString (Extension)


/**验证是不是QQ号码*/
//匹配QQ号码,匹配规则:全部是都是数字,第一个字符非0,长度为(6~11)
- (BOOL) isQQ {
    
    NSString *pattern = @"^[1-9]\\d{5,10}$";
    return [self matchWithPattern:pattern];
}


//  手机号码的匹配
//  匹配手机号码,匹配规则:以0或86或空开头,后面第一个数字为"1",当第二数字为 "3,5,8" 第三个数字为"0-9",当第二数字为"7" 第三个数字为"6或7或8",当第二个数字为"4"时,第三个数字为"5或7",手机号码位数为11位.
- (BOOL) isPhone {
    NSString *pattern = @"^(0|86)?1([358]\\d|7[678]|4[57])\\d{8}$";
    return [self matchWithPattern:pattern];
}

//  邮箱匹配：
- (BOOL) isEmail{
    NSString  *pattern = @"^[a-z0-9]+([\\._\\-]*[a-z0-9])*@([a-z0-9]+\\-*[a-z0-9]+\\.){1,63}[a-z0-9]+$";
    return [self matchWithPattern:pattern];
}

//匹配字符串

- (BOOL) matchWithPattern:(NSString *) pattern {
    NSError *error = nil;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) {
        NSLog(@"创建正则表达式失败%@",error);
        return NO;
    }
    
    //  匹配
    NSTextCheckingResult *results  = [regularExpression firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (results) {
        return YES;
    }else {
        return NO;
    }
}

- (CGFloat)getHeightWithLimitWidth:(CGFloat)width fontSize:(CGFloat)size
{
    UIFont *font = [UIFont systemFontOfSize:size];
    NSDictionary *attrs = @{NSFontAttributeName :font};
    return [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
}

- (CGFloat)getWidthWithLimitHeight:(CGFloat)Height fontSize:(CGFloat)size
{
    UIFont *font = [UIFont systemFontOfSize:size];
    NSDictionary *attrs = @{NSFontAttributeName :font};
    return [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, Height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}

/**
 *  返回字符串占用的尺寸
 *
 *  @param font    要计算文字的字体
 *  @param maxSize 文字的最大尺寸
 *
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}


//判断字符串是否为浮点数
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

//判断是否为整形：
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


+(NSString *)toCapitalLetters:(NSString *)money
{
    //首先转化成标准格式        “200.23”
    NSMutableString *tempStr=[[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%.2f",[money doubleValue]]];
    //位
    NSArray *carryArr1=@[@"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"兆", @"拾", @"佰", @"仟" ];
    NSArray *carryArr2=@[@"分",@"角"];
    //数字
    NSArray *numArr=@[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];
    
    NSArray *temarr = [tempStr componentsSeparatedByString:@"."];
    //小数点前的数值字符串
    NSString *firstStr=[NSString stringWithFormat:@"%@",temarr[0]];
    //小数点后的数值字符串
    NSString *secondStr=[NSString stringWithFormat:@"%@",temarr[1]];
    
    //是否拼接了“零”，做标记
    bool zero=NO;
    //拼接数据的可变字符串
    NSMutableString *endStr=[[NSMutableString alloc] init];
    
    /**
     *  首先遍历firstStr，从最高位往个位遍历    高位----->个位
     */
    
    for(int i=(int)firstStr.length;i>0;i--)
    {
        //取最高位数
        NSInteger MyData=[[firstStr substringWithRange:NSMakeRange(firstStr.length-i, 1)] integerValue];
        
        if ([numArr[MyData] isEqualToString:@"零"]) {
            
            if ([carryArr1[i-1] isEqualToString:@"万"]||[carryArr1[i-1] isEqualToString:@"亿"]||[carryArr1[i-1] isEqualToString:@"元"]||[carryArr1[i-1] isEqualToString:@"兆"]) {
                //去除有“零万”
                if (zero) {
                    endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:(endStr.length-1)]];
                    [endStr appendString:carryArr1[i-1]];
                    zero=NO;
                }else{
                    [endStr appendString:carryArr1[i-1]];
                    zero=NO;
                }
                
                //去除有“亿万”、"兆万"的情况
                if ([carryArr1[i-1] isEqualToString:@"万"]) {
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"亿"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                    
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"兆"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                    
                }
                //去除“兆亿”
                if ([carryArr1[i-1] isEqualToString:@"亿"]) {
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"兆"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                }
                
                
            }else{
                if (!zero) {
                    [endStr appendString:numArr[MyData]];
                    zero=YES;
                }
                
            }
            
        }else{
            //拼接数字
            [endStr appendString:numArr[MyData]];
            //拼接位
            [endStr appendString:carryArr1[i-1]];
            //不为“零”
            zero=NO;
        }
    }
    
    /**
     *  再遍历secondStr    角位----->分位
     */
    
    if ([secondStr isEqualToString:@"00"]) {
        [endStr appendString:@"整"];
    }else{
        for(int i=(int)secondStr.length;i>0;i--)
        {
            //取最高位数
            NSInteger MyData=[[secondStr substringWithRange:NSMakeRange(secondStr.length-i, 1)] integerValue];
            
            [endStr appendString:numArr[MyData]];
            [endStr appendString:carryArr2[i-1]];
        }
    }
    
    return endStr;
}


@end
