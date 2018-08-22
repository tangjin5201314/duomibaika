//
//  LZKAutoLayout.h
//  testWeb
//
//  Created by 李哲楷 on 16/7/22.
//  Copyright © 2016年 李哲楷. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark - LZKStackViewType

/**
 对齐类型
 */
typedef enum : NSUInteger {
    /**
     *  水平对齐
     */
    LZKStackViewTypeHorizontal,
    /**
     *  纵向对齐
     */
    LZKStackViewTypeVertical,
} LZKStackViewType;

#pragma mark - LZKStackView class

@interface LZKStackView : UIView

/**
 *  内边距
 */
@property (assign,nonatomic) UIEdgeInsets padding;

/**
 *  view之间的距离
 */
@property (assign,nonatomic) CGFloat space;

/**
 *  根据对齐类型进行布局
 *
 *  @param type ZXPStackViewTypeHorizontal or ZXPStackViewTypeVertical
 */
- (void)layoutWithType:(LZKStackViewType)type;

@end


#pragma mark - LZKConstraintMaker class

@interface LZKConstraintMaker : NSObject

/**
 *  设置make在superview中的约束
 */
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^top)(CGFloat value);
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^left)(CGFloat value);
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^right)(CGFloat value);
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^bottom)(CGFloat value);
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^width)(CGFloat value);
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^height)(CGFloat value);
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^centerX)(CGFloat value);
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^centerY)(CGFloat value);


/**
 *  设置需要参考的子view，需要首先设置
 */
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^LZK_equalTo)(UIView *view);

@property (copy, nonatomic, readonly) LZKConstraintMaker *with;
/**
 *  设置make在某个view中的约束
 */

@property (copy, nonatomic, readonly) LZKConstraintMaker *(^LZK_top)(CGFloat value);
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^LZK_left)(CGFloat value);
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^LZK_right)(CGFloat value);
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^LZK_bottom)(CGFloat value);
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^LZK_width)(CGFloat value);
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^LZK_height)(CGFloat value);
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^LZK_centerX)(CGFloat value);
@property (copy, nonatomic, readonly) LZKConstraintMaker *(^LZK_centerY)(CGFloat value);

//init
- (instancetype)initWithView:(UIView *)view type:(id)type;

@end

#pragma mark - category UIView + LZKAdditions

@interface UIView (LZKAdditions)

/**
 *  添加布局
 *
 *  @param layout 布局
 */
- (void)lzk_addConstraints:(void(^)(LZKConstraintMaker *layout))layout;

/**
 *  更新布局
 *
 *  @param layout 布局
 */
- (void)lzk_updateConstraints:(void(^)(LZKConstraintMaker *layout))layout;

/**
 *  输出布局
 */
- (void)lzk_printConstraintsForSelf;

@end

#pragma mark - category UITableView + LZKCellAutoHeight

@interface UITableView (LZKCellAutoHeight)

/**
 *  cell的高度自适应, 在tableView: cellForRowAtIndexPath: 方法里请用
 [tableView dequeueReusableCellWithIdentifier:cellid];
 方式获取cell
 
 请不要使用
 [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
 会造成野指针错误
 *
 *  @param indexPath 索引
 *
 *  @return 返回cell.contentView的子视图里 y+height 最大值的数值
 */
- (CGFloat)lzk_cellHeightWithindexPath:(NSIndexPath *)indexPath;


/**
 *  cell的高度自适应, 在tableView: cellForRowAtIndexPath: 方法里请用
 [tableView dequeueReusableCellWithIdentifier:cellid];
 方式获取cell
 
 请不要使用
 [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
 会造成野指针错误
 *
 *  @param indexPath 索引
 *  @param space     附加距离空间
 *
 *  @return y+height +space
 */
- (CGFloat)lzk_cellHeightWithindexPath:(NSIndexPath *)indexPath space:(CGFloat)space;

/**
 *  cell的高度自适应, 在tableView: cellForRowAtIndexPath: 方法里请用
 [tableView dequeueReusableCellWithIdentifier:cellid];
 方式获取cell
 
 请不要使用
 [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
 会造成野指针错误
 *
 *  @param indexPath 索引
 *  @param block     返回view
 *
 *  @return block的view y+height
 */
- (CGFloat)lzk_cellHeightWithindexPath:(NSIndexPath *)indexPath bottomView:(UIView *(^)(__kindof UITableViewCell *cell))block;

/**
 *  cell的高度自适应, 在tableView: cellForRowAtIndexPath: 方法里请用
 [tableView dequeueReusableCellWithIdentifier:cellid];
 方式获取cell
 
 请不要使用
 [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
 会造成野指针错误
 *
 *  @param indexPath 索引
 *  @param block     返回view
 *  @param space     附加距离空间
 *
 *  @return block的view y+height+space
 */
- (CGFloat)lzk_cellHeightWithindexPath:(NSIndexPath *)indexPath bottomView:(UIView *(^)(__kindof UITableViewCell *cell))block space:(CGFloat)space;


@end

