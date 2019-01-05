# 合约接口说明

DonateFactory合约有2个接口：

1、createContract 用于创建捐助合约，需要求助信息，包括募集目标金额、标题、信息描述、求助者账户地址、材料存放地址、材料hash和求助者账户

2、getDeployedContracts 获取所有捐助合约地址


SimpleDonateContract合约有2个接口：

1、donate 捐钱，在未募到目标金额前，接收捐款，且每笔不低于0.01 trx

2、withdraw  达到募集目标金额，即可提现

准备添加的接口：

1、approve 求助人给医院授信，允许医院取多少钱。求助人专用

2、allowance 查询某个账户的剩余授信额度。对外公开

3、increaseApproval 增加某个账户的授信额度。求助人专用

5、decreaseApproval 减少某个账户的授信额度。求助人专用