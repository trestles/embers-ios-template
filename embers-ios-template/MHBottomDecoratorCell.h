//
//  MHBottomDecoratorCell.h
//  
//
//  Created by jonathan twaddell on 8/28/14.
//
//

#import <UIKit/UIKit.h>

@interface MHBottomDecoratorCell : UITableViewCell
  @property (nonatomic, assign) CGFloat height;
  -(void)updateCell:(NSDictionary *)tmpDic;
@end
