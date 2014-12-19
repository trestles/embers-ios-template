//
//  MHBottomDecoratorCell.m
//  
//
//  Created by jonathan twaddell on 8/28/14.
//
//

#import "MHBottomDecoratorCell.h"
#import "MYUtility.h"

@implementation MHBottomDecoratorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
  }
  self.height=40.0f;
  return self;
}

- (void)awakeFromNib
{
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateCell:(NSDictionary *)tmpDic
{
  UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 240.0f, 0.0f)];
  myLabel.text=[tmpDic objectForKey:@"name"];
  myLabel.font=MYMainFont();

  myLabel.numberOfLines=0;
  [myLabel sizeToFit];
  self.height=myLabel.frame.size.height + 20.0f;
  myLabel.frame=CGRectMake((320.0f - myLabel.frame.size.width)/2, 10.0f, myLabel.frame.size.width, myLabel.frame.size.height);
  myLabel.frame=CGRectMake(40.0f, 10.0f, myLabel.frame.size.width, myLabel.frame.size.height);

  [self.contentView addSubview:myLabel];
}


@end
