//
//  BetterTableViewVC.m
//  KunshanTalent
//
//  Created by ligh on 13-11-7.
//
//

#import "BetterTableViewVC.h"


@interface BetterTableViewVC ()
{
    
        NSMutableArray         *_dataArray;
        NSMutableArray         *_registeredCellIdentifierArray;
}
@end

@implementation BetterTableViewVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSIndexPath *indexPath = _tableView.indexPathForSelectedRow;
    if(indexPath)
    {
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    _registeredCellIdentifierArray = [NSMutableArray array];
}

-(void)configViewController
{
    [super configViewController];
    _dataArray = [NSMutableArray array];
    
    //config tableView
    if(!_tableView)
    {
        UIView *parentView = self.contentView ? self.contentView : self.view;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, parentView.width,parentView.height) style:UITableViewStylePlain];

        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [parentView addSubview:_tableView];
    }
    
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addHeader];
    [self addFooter];
    

    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if ([_tableView respondsToSelector:@selector(separatorInset)])
    {
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.separatorColor = UIColorFromRGB(220, 220, 220);
    }
    
    [self setExtraCellLineHidden:_tableView];

    [_tableView setFooterHidden:YES];
    
    if ([self respondsToSelector:@selector(extendedLayoutIncludesOpaqueBars)])
    {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}


//
- (void)addHeader
{
    
    __weak BetterTableViewVC *weakSelf = self;
    __weak UITableView       *weakTableView = _tableView;
    
    // 添加下拉刷新头部控件
    [_tableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [weakSelf pullTableViewDidTriggerRefresh:weakTableView];
    }];
    
   
}

- (void)addFooter
{
    
    __weak BetterTableViewVC *weakSelf = self;
    __weak UITableView       *weakTableView = _tableView;
    
    // 添加上拉刷新尾部控件
    [_tableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf pullTableViewDidTriggerLoadMore:weakTableView];
    }];
    
    [_tableView setFooterHidden:YES];
}

/**
 * 隐藏talbeView多余的分割线
 *
 *  @param tableView 要隐藏分割线的tableView
 */
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


-(void)clickPromptViewAction
{
   [self pullTableViewDidTriggerRefresh:_tableView];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark  config data
///////////////////////////////////////////////////////////////////////////////
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
//设置Cell数据默认实现
-(void)tableViewCell:(UITableViewCell *)cell configCellForData:(id)data
{

 
}

-(NSArray *)dataArray
{
    return _dataArray;
}

-(void)setDataArray:(NSArray *)dataArray
{
    [_dataArray removeAllObjects];
    if(dataArray != nil)
    {
        [_dataArray addObjectsFromArray:dataArray];
        [_tableView reloadData];
    }
}


-(void)setPageModel:(PageModel *)pageModel
{
    
    [self hidePromptView];
    
    [_tableView setFooterHidden:!pageModel.isMoreData];
    [self endPullRefresh];
    
    if(pageModel == nil)
    {
        return;
    }
    
    if (pageModel!= _pageModel)
    {
        RELEASE_SAFELY(_pageModel);
        _pageModel = pageModel;
    }
    
    if (pageModel.pagenow.intValue <= 1 )
    {
        [self setDataArray:pageModel.listArray];
        
    } else
    {
        [self appendDataArray:pageModel.listArray];
    }


}

-(void)appendDataArray:(NSArray *)dataArray
{
    [_dataArray addObjectsFromArray:dataArray];
    [_tableView reloadData];

 //   [self showNoDataPromptView];
}

-(void)clearDataArray
{
    [_dataArray removeAllObjects];
    [_tableView reloadData];
    
  //  [self showNoDataPromptView];
}


-(void)removeDataAtIndex:(NSInteger)index
{
    [_dataArray removeObjectAtIndex:index];
    

}

-(void)removeDataAtIndexAndReload:(NSInteger)index
{
    [self removeDataAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]  withRowAnimation:UITableViewRowAnimationMiddle];

}

-(void)removeForData:(id)data
{
    [self  removeDataAtIndex:[_dataArray indexOfObject:data]];
    
    
}

-(void) removeForDataAndReload:(id)data
{
 
    [self  removeDataAtIndexAndReload:[_dataArray indexOfObject:data]];
}


-(void)disablePullRefresh
{
    [_tableView setFooterHidden:YES];
    [_tableView setHeaderHidden:YES];
}

-(void)endPullRefresh
{
 
    [_tableView headerEndRefreshing];
  [_tableView footerEndRefreshing];
}


-(void)showPromptViewWithText:(NSString *)text
{
    [[self promptView] setPromptText:text];
    self.promptView.height = self.tableView.height;
    [self.tableView addSubview:[self promptView]];
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark  views action
///////////////////////////////////////////////////////////////////////////////
-(void)actionClickNavigationBarRightButton
{
    
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark  UITableViewDelegate/UITableViewDataSource
///////////////////////////////////////////////////////////////////////////////
-(void)pullTableViewDidTriggerLoadMore:(UITableView *)pullTableView
{
}

-(void)pullTableViewDidTriggerRefresh:(UITableView *)pullTableView
{

}


/**
计算cell高度
 **/
-(CGFloat) cellHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id cellClass = [self cellClassForIndexPath:indexPath];
    
    //如果该cell nib没有注册 先注册
    NSString *Identifier = NSStringFromClass(cellClass);
    if(![_registeredCellIdentifierArray containsObject:Identifier]) {
        [_registeredCellIdentifierArray addObject:Identifier];
        [self.tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
    }

    return [self.tableView fd_heightForCellWithIdentifier:NSStringFromClass(cellClass) cacheByIndexPath:indexPath configuration:^(UITableViewCell * cell) {
      
        cell.fd_enforceFrameLayout = YES;
        
        if ([cell isKindOfClass:[BetterTableCell class]])
        {
            BetterTableCell *baseCell = (BetterTableCell *)cell;
            [baseCell setCellData:_dataArray[indexPath.row]];
         
        }
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return defult
    return _dataArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //获取当前Cell的class
    Class cellClass = [self cellClassForIndexPath:indexPath];
    
    //如果该cell nib没有注册 先注册
    NSString *Identifier = NSStringFromClass(cellClass);
    if(![_registeredCellIdentifierArray containsObject:Identifier]) {
        [_registeredCellIdentifierArray addObject:Identifier];
        [self.tableView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellReuseIdentifier:Identifier];
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
   
    //强制使用sizeFit计算高度
    cell.fd_enforceFrameLayout = YES;

        if ([self respondsToSelector:@selector(tableViewCell:configCellForIndexPath:)])
        {
            [self tableViewCell:cell configCellForIndexPath:indexPath];
            
        }else
        {
            
            if(_dataArray.count)
            {
                if ([cell isKindOfClass:[BetterTableCell class]])
                {
                    BetterTableCell *baseCell = (BetterTableCell *)cell;
                    [baseCell setCellData:_dataArray[indexPath.row]];
                    [baseCell setCellIndex:indexPath.row];
                }
                
                [self tableViewCell:cell configCellForData:_dataArray[indexPath.row]];
            }
        }

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
