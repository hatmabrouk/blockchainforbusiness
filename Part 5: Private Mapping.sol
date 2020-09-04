pragma solidity 0.6.6;

contract Identity{

    struct Person{
        string name;
        uint age;
        uint height;
    }
    
    mapping (address => Person) private people;
    
    function createPerson (string memory name, uint age, uint height) public{
       
        address creator = msg.sender;
       
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
     
        people [creator] = newPerson;
    }
    
    function getPerson () public view returns (string memory name, uint age, uint height){
    address creator = msg.sender;
    return (people [creator].name, people [creator].age, people [creator].height); 
    }
}
