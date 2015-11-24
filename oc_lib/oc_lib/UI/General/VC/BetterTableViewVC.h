//
//  BetterTableViewVC.h
//  KunshanTalent
//
//  Created by ligh on 13-11-7.
//
//

#import "BetterVC.h"
#import "BetterTableCell.h"
#import "PageModel.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface BetterTableViewVC : BetterVC  <UITableViewDataSource,UITableViewDelegate>

///////////////////////////////////////////////////////////////////////////////
#pragma mark  Views
///////////////////////////////////////////////////////////////////////////////

//展示的TableView
@property (strong,nonatomic) IBOutlet UITableView   *tableView;

///////////////////////////////////////////////////////////////////////////////
#pragma mark  data
///////////////////////////////////////////////////////////////////////////////

@property (strong,nonatomic) PageModel *pageModel;

//获取目前的数据
-(NSArray *) dataArray;
//设置数据 清空原有数据
-(void) setDataArray:(NSArray *) dataArray;
//追加数据
-(void) appendDataArray:(NSArray *) dataArray;

//清空数据
-(void) clearDataArray;
-(void) removeDataAtIndex:(NSInteger) index;
-(void) removeDataAtIndexAndReload:(NSInteger) index;

-(void) removeForData:(id) data;
-(void) removeForDataAndReload:(id) data;

//禁用下拉刷新和上提加载更多
-(void) disablePullRefresh;
-(void) endPullRefresh;



///////////////////////////////////////////////////////////////////////////////
#pragma mark  data
///////////////////////////////////////////////////////////////////////////////
-(CGFloat) cellHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
//返回TableView要显示的Cell class
-(Class)    cellClassForIndexPath:(NSIndexPath *) indexPath;
-(void)     tableViewCell:(UITableViewCell *)cell configCellForData:(id)data;
-(void)     tableViewCell:(UITableViewCell *)cell configCellForIndexPath:(NSIndexPath *)indexPath;



@end
