pragma solidity ^0.4.14;

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

contract Donate is Ownable {

    event AddFund(address indexed from, uint value);
    event ExtractFund(address indexed from, uint value);

    function Donate() payable public {
        
    }

    function addFund() payable public returns (uint) {
        AddFund(msg.sender, msg.value);
        return address(this).balance;
    }

    function extractFund() onlyOwner {
        ExtractFund(msg.sender, address(this).balance);
        selfdestruct(owner);
    }
}

