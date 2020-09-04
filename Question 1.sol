pragma solidity 0.6.6;

contract HelloWorld {
    
string public message = "Hello World;

uint public number = 123;

bool public ishappy = true

address public contractCreator = 0xBf2916234279507F56f8A4F79889529dd9CCA018;

uint [] public numbers = [1,20,45];

string [] public messages = ["hello", "hello hatem", "hello world"];

function getMessage () public view returns (string memory){
return message;
    }
}
