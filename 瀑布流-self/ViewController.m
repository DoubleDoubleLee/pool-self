//
//  ViewController.m
//  瀑布流-self
//
//  Created by qianfeng on 15/10/22.
//  Copyright (c) 2015年 Double Lee. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#define IMAGE_WIDTH ([UIScreen mainScreen].bounds.size.width-GAP*2)/3
#define HEIGHT [UIScreen mainScreen].bounds.size.height
#define GAP 10//边界

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * _tableV;
    
    NSMutableArray *_dataSource;//存储所有图片的数组
    NSMutableArray *_threeTableVDataSource;//三个数据源 三个数组 每个数组对应一个tableV;
    NSMutableArray * _tableVArr;//保存所有的tableV;
    //保存每个tableV已经显示的图片的高度
    CGFloat _imageHeight[3];
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.拿到所有的图片
    [self initDataSource];
    //2.配置每个tableView的数据源
    [self initEachTableDataSource];
    //3.展示
    [self createUI];
}
#pragma mark--获取所有的图片
-(void)initDataSource{
    _dataSource=[[NSMutableArray alloc]init];
    for (int i=0; i<200; i++) {
       NSString * imageName=[NSString stringWithFormat:@"image%.2d.jpg",i%16];
   //     NSString * imageName=[NSString stringWithFormat:@"%.2d.jpg",i%16];
        UIImage * image=[UIImage imageNamed:imageName];
        [_dataSource addObject:image];
    }
}
#pragma mark--配置每个tableV的数据源
-(void)initEachTableDataSource{
    //1.实例化装有三个tableV的数据源
    _threeTableVDataSource=[[NSMutableArray alloc]init];
    for (int i=0; i<3; i++) {
        //2.实例化每个tableV的数据源
        NSMutableArray * subTable=[[NSMutableArray alloc]init];
        
        [_threeTableVDataSource addObject:subTable];
    }
    //3.给每个数据源分配图片
    for (UIImage * image in _dataSource) {
        //3.1拿到数据源中所有图片高度最短的那个数据源
        NSMutableArray * shortArr=[self shortDataSource];
        //3.2把图片加到这个数据源中
        [shortArr addObject:image];
        //3.3更新最短数据源的高度
        [self updateShortDataSourceHeight:shortArr];
    }
}
#pragma mark--返回最短的那个数据源
-(NSMutableArray*)shortDataSource{
    //假设第一个tableView里所有的图片的高度最低
    CGFloat shortHeight = _imageHeight[0];
    //记录下标 指明图片总体高度最低的是哪个tableView
    int min=0;
    //找到图片整体高度最低的那个数据源
    for (int i=0; i<=2; i++) {
        if (_imageHeight[i]<shortHeight) {
            shortHeight=_imageHeight[i];
            min=i;
        }
    }
    return _threeTableVDataSource[min];
}
#pragma mark--更新最短的数据源的高度
-(void)updateShortDataSourceHeight:(NSMutableArray*)shortArray{
    //1.拿到最低的那个数据源的位置
    NSInteger index=[_threeTableVDataSource indexOfObject:shortArray];
    //2.先拿到要更新的数据源之前的高度
 //   CGFloat heigh=_imageHeight[index];
    
    //拿到图片 最后的那张图片
    UIImage * image=[shortArray lastObject];
    //3.更新高度
    _imageHeight[index] += [self imageHeightWithImage:image];
}
#pragma mark--求得图片高度
-(CGFloat)imageHeightWithImage:(UIImage*)image{
    //等比压缩
    return image.size.height*IMAGE_WIDTH/image.size.width;
}
#pragma mark--展示
-(void)createUI{
    _tableVArr=[[NSMutableArray alloc]init];
    for (int i=0; i<3; i++) {
        _tableV=[[UITableView alloc]initWithFrame:CGRectMake((IMAGE_WIDTH+GAP)*i , 0, IMAGE_WIDTH,self.view.frame.size.height)style:UITableViewStylePlain];
        _tableV.delegate=self;
        _tableV.dataSource=self;
        //隐藏滑块
        _tableV.showsVerticalScrollIndicator=NO;
        [self.view addSubview:_tableV];
        //将创建的tableV放到数组里面
        [_tableVArr addObject:_tableV];
    }
}
#pragma mark--tableV的协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //拿到当前的tableV的索引
    NSInteger index=[_tableVArr indexOfObject:tableView];
    //取到当前tableV图片的数据源
    NSMutableArray * dataSource=_threeTableVDataSource[index];
    
    return dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //确定是哪一个tableView
    NSInteger index=[_tableVArr indexOfObject:tableView];
    NSMutableArray * dataSource=_threeTableVDataSource[index];
    //取到数据源中的图片
    UIImage * image=dataSource[indexPath.row];
    //取到当前图片的高度
    return [self imageHeightWithImage:image];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //自定制cell
    TableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSInteger index=[_tableVArr indexOfObject:tableView];
    NSMutableArray * dataSource=_threeTableVDataSource[index];
    UIImage * image=dataSource[indexPath.row];
    [cell setImage:image width:IMAGE_WIDTH height:[self imageHeightWithImage:image]];
    return cell;
}
#pragma mark--设置tableView的联动 需要scrollV的协议方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //1.拿到你滑动的tableView
 //   NSInteger index =[_tableVArr indexOfObject:scrollView];
    //遍历tableView
    for (UITableView * tableV in _tableVArr) {
        if (tableV==scrollView) {//选取到当前的scrollV
            continue;
        }
        //内容设置的大小尺寸 返回CGPoint
        tableV.contentOffset=scrollView.contentOffset;
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
