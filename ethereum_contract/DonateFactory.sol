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

/**
 * @title SafeMath
 * @dev Math operations with safety checks that throw on error
 */
library SafeMath {

  /**
  * @dev Multiplies two numbers, throws on overflow.
  */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }

  /**
  * @dev Integer division of two numbers, truncating the quotient.
  */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    // assert(b > 0); // Solidity automatically throws when dividing by 0
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold
    return c;
  }

  /**
  * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }

  /**
  * @dev Adds two numbers, throws on overflow.
  */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
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
    using SafeMath for uint256;
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    mapping (address => uint256) allowed;

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
      donateInfo.amount = _amount.mul(1 ether);
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

/**
   * @dev extract tokens
   * @param _value uint256 the amount of tokens to be transferred
   */
  function transfer(uint256 _value) public returns (bool) {
    uint256 _allowance = allowed[msg.sender];

    // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
    // require (_value <= _allowance);
    _value = _value.mul(1 ether);

    allowed[msg.sender] = _allowance.sub(_value);
    msg.sender.transfer(_value);
    Transfer(address(this), msg.sender, _value);
    return true;
  }

  /**
   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
   *
   * Beware that changing an allowance with this method brings the risk that someone may use both the old
   * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
   * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   * @param _spender The address which will spend the funds.
   * @param _value The amount of tokens to be spent.
   */
  function approve(address _spender, uint256 _value) public onlyDonateTo returns (bool) {
    _value = _value.mul(1 ether);
    require(address(this).balance > _value);
    allowed[_spender] = _value;
    Approval(msg.sender, _spender, _value);
    return true;
  }

  /**
   * @dev Function to check the amount of tokens that an owner allowed to a spender.
   * @param _spender address The address which will spend the funds.
   * @return A uint256 specifying the amount of tokens still available for the spender.
   */
  function allowance(address _spender) public constant returns (uint256 remaining) {
    return allowed[_spender];
  }

  /**
   * approve should be called when allowed[_spender] == 0. To increment
   * allowed value is better to use this function to avoid 2 calls (and wait until
   * the first transaction is mined)
   * From MonolithDAO Token.sol
   */
  function increaseApproval(address _spender, uint _addedValue) onlyDonateTo
    returns (bool success) {
    _addedValue = _addedValue.mul(1 ether);
    allowed[_spender] = allowed[_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[_spender]);
    return true;
  }

  function decreaseApproval(address _spender, uint _subtractedValue) onlyDonateTo
    returns (bool success) {
    uint oldValue = allowed[_spender];
    _subtractedValue = _subtractedValue.mul(1 ether);
    if (_subtractedValue > oldValue) {
      allowed[_spender] = 0;
    } else {
      allowed[_spender] = oldValue.sub(_subtractedValue);
    }
    Approval(msg.sender, _spender, allowed[_spender]);
    return true;
  }
}