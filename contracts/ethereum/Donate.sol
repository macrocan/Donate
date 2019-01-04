pragma solidity ^0.4.17;

// import './Ownable.sol';

/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
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
        OwnershipTransferred(owner, newOwner);
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

contract Donate is Ownable {
    using SafeMath for uint256;

    event AddFund(address indexed from, uint value);
    event ExtractFund(address indexed from, uint value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    mapping (address => uint256) allowed;

    function Donate() payable public {
        
    }

    function addFund() payable public returns (uint) {
        AddFund(msg.sender, msg.value);
        return address(this).balance;
    }

    // Need?
    function extractFund(uint value) onlyOwner private {
        ExtractFund(msg.sender, value);
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
  function approve(address _spender, uint256 _value) public onlyOwner returns (bool) {
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
  function increaseApproval(address _spender, uint _addedValue) onlyOwner
    returns (bool success) {
    _addedValue = _addedValue.mul(1 ether);
    allowed[_spender] = allowed[_spender].add(_addedValue);
    Approval(msg.sender, _spender, allowed[_spender]);
    return true;
  }

  function decreaseApproval(address _spender, uint _subtractedValue) onlyOwner
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

