pragma solidity ^0.4.21;

contract Ownable {
address public owner;

event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

/**
* @dev The Ownable constructor sets the original `owner` of the contract to the sender
* account.
*/
function Ownable() public {
owner = msg.sender;
}


/**
* @dev Throws if called by any account other than the owner.
*/
modifier onlyOwner() {
require(msg.sender == owner);
_;
}


/**
* @dev Allows the current owner to transfer control of the contract to a newOwner.
* @param newOwner The address to transfer ownership to.
*/
function transferOwnership(address newOwner) public onlyOwner {
require(newOwner != address(0));
emit OwnershipTransferred(owner, newOwner);
owner = newOwner;
}

}

contract DonateFactory is Ownable{
   address[] DonateContracts;
   function createContract(uint _amount,string _title, string _desc,int _materialHash,string _materialUrl, address _donateToAddr) public payable {
      address donateContract = new SimpleDonateContract(_amount, _title, _desc,  _materialHash, _materialUrl, _donateToAddr);            
      DonateContracts.push(donateContract);   
   }
   function getDeployedContracts() public view returns (address[]) {
      return DonateContracts;
   }
}

contract BaseDonateContract is Ownable {
  uint minAmount = 0.01 ether;
  event Donate(address indexed donateFrom, address indexed donateTo, address contractAddr);
  address donateToAddr; //受助人地址addr
  modifier onlyDonateTo() {
    require(msg.sender == donateToAddr);
    _;
  }
}

contract SimpleDonateContract is BaseDonateContract{
   
   bool isSuc = false;
   struct DonateInfo {
        uint256 amount;//筹款金额
        string title; //筹款标题
        string desc; //求助说明
        int materialHash; //图片hash
        string materialUrl;//图片url
    }
    
    DonateInfo public donateInfo;

   
   function SimpleDonateContract(uint256 _amount, string _title, string _desc,int _materialHash,string _materialUrl, address _donateToAddr) public {
      donateInfo.amount = _amount * 1 ether;
      donateInfo.title = _title;
      donateInfo.desc = _desc;
      donateInfo.materialHash = _materialHash;
      donateInfo.materialUrl = _materialUrl;
      donateToAddr = _donateToAddr;
      
   }
   
   function donate() external payable { //捐助
    require(msg.value >= minAmount && address(this).balance < donateInfo.amount);
    // 
    if(address(this).balance >= donateInfo.amount) {
      isSuc = true;
      emit Donate(msg.sender,   donateToAddr,  this);
    }
    
  }
  
  function withdraw() external onlyDonateTo { //取回
    if(isSuc){
      donateToAddr.transfer(address(this).balance);
    }
  }

}