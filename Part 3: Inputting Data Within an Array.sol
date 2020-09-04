pragma solidity 0.6.6;
contract Identity{
struct Person {
    string name;
    uint height;
    uint age;
}
Person [] public people;
function createPerson (string memory name, uint height, uint age) public{
        
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        people.push (newPerson);
}
}
