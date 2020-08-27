pragma solidity 0.6.6;

contract HelloWorld{
    
string public message = "Hello World";

uint public number = 123;

bool public ishappy = true;

address public contractCreator = 0xBf2916234279507F56f8A4F79889529dd9CCA018;

uint [] public numbers = [1,20,45];
//This array here does not need a function, but there is the getNumber function to see how the function works.

string [] public messages = ["hello", "hello hatem", "hello world"];
// This array does not need a function to be displayed.

function getMessage() public view returns (string memory){
return message;
    }

function setMessage (string memory newMessage) public{
message = newMessage;
    }
    
function getNumber (uint index) public view returns (uint){
    return numbers [index];
}
function setNumber (uint newNumber, uint index) public{
    numbers [index] = newNumber;
}
function addNumber (uint newNumber) public {
    numbers.push (newNumber);
}
}
