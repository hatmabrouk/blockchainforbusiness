pragma solidity 0.6.6;

contract HelloWorld {
    
string public message = "Hello World";

uint [] public numbers = [1,20,45];
//This array here does not need a function, but there is the getNumber function to see how the function works.

string [] public messages = ["hello", "hello Karla", "hello world"];
// This array does not need a function to be displayed.

function setMessage (string memory newMessage) public{
message = newMessage;
    }
    
function addNumber (uint newNumber) public {
    numbers.push (newNumber);
}
}
