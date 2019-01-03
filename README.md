# Donate
Donate Dapp Github

Below is framework
![image](https://github.com/HiZhongxh/Donate/blob/master/framework.jpg?raw=true)




# 合约接口说明

manage.sol合约有2个接口：

1、getdoner 用户获取特定求助人的求助信息 可以对外

2、addDonor 用于添加登记求助信息，包括求助者账户地址、捐助合约地址、材料存放地址和总的材料hash 前端专用

管理合约只能由前端操作，因此前端需要维护一个账户


donate.sol有5个接口：

1、addFund 向求助人捐款，捐款人专用

2、approve 求助人给医院授信，允许医院取多少钱。求助人专用

3、allowance 查询某个账户的剩余授信额度。对外公开

4、increaseApproval 增加某个账户的授信额度。求助人专用

5、decreaseApproval 减少某个账户的授信额度。求助人专用


