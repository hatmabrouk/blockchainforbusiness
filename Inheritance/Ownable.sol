pragma solidity 0.6.6;
contract Ownable {
       
        address public owner;

        modifier onlyOwner (){
        require (msg.sender == owner); 
        _; 
    }
        constructor () public{
        owner = msg.sender;
    }
}
