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

contract Manage is Ownable {

    event AddDonor(address indexed from, address donorAddr, address contractAddr);
    event Resolve(address indexed from, uint value);

    struct DonateInfo {
        address contractAddr;
        string materialsAddr;
        string materialHash;
    }

    mapping(address => DonateInfo) public contracts;
    
    function Manage() payable public {
        
    }

    function addDonor(address donorAddr, address contractAddr, string materialsAddr, string materialHash) onlyOwner {
        AddDonor(msg.sender, donorAddr, contractAddr);
        contracts[donorAddr] = DonateInfo(contractAddr, materialsAddr, materialHash);
    }

    function getDonor(address donorAddr) returns (address contractAddr, string materialsAddr, string materialHash) {
        contractAddr = contracts[donorAddr].contractAddr;
        materialsAddr = contracts[donorAddr].materialsAddr;
        materialHash = contracts[donorAddr].materialHash
    }

    function resolve() onlyOwner {
        Resolve(msg.sender, address(this).balance);
        selfdestruct(owner);
    }
}

