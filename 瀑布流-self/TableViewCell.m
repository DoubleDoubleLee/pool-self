//
//  TableViewCell.m
//  瀑布流-self
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 Double Lee. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell
{
    UIImageView * _imageV;
}
//重写cell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addImageView];
    }
    return self;
}

-(void)addImageView{
    _imageV=[[UIImageView alloc]init];
    [self.contentView addSubview:_imageV];
}
-(void)setImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height{
    _imageV.image=image;
    _imageV.frame=CGRectMake(0, 0, width, height);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
