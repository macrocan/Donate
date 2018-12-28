pragma solidity ^0.4.14;

import './Ownable.sol';

contract Donate is Ownable {

    event AddFund(address indexed from, uint value);
    event ExtractFund(address indexed from, uint value);

    function addFund() payable public returns (uint) {
        AddFund(msg.sender, msg.value);
        return address(this).balance;
    }

    function extractFund() onlyOwner {
        ExtractFund(msg.sender, address(this).balance)
        selfdestruct(owner);
    }
}

