pragma solidity ^0.4.14;

import './Ownable.sol';

contract Manage is Ownable {

    event AddDonor(address indexed from, address donorAddr, address contractAddr);
    event Resolve(address indexed from, uint value);

    mapping(address => address) public contracts;

    function addDonor(address donorAddr, address contractAddr) onlyOwner {
        AddDonor(msg.sender, donorAddr, contractAddr);
        contracts[donorAddr] = contractAddr;
    }

    function resolve() onlyOwner {
        Resolve(msg.sender, address(this).balance);
        selfdestruct(owner);
    }
}

