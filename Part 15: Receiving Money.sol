pragma solidity 0.6.6;
contract Identity{
    struct Person {
        string name;
        uint age;
        uint height;
        bool senior;
    }

event personCreated (string name, bool senior);
event personDeleted (string name, bool senior, address deletedBy);


modifier onlyOwner () {
    require (msg.sender == owner);
    _;
}

address public owner;
uint public balance;

constructor () public{
    owner = msg.sender;
}
    
mapping (address => Person) private people;
address [] private creators;


function createPerson (string memory name, uint age, uint height) public payable{
require (age < 150, "age must be less than 150");
require (msg.value >= 1 ether);
balance += msg.value;
//this adds the value to the balance that you defined as a state variable above.

Person memory newPerson;
newPerson.name = name;
newPerson.age = age;
newPerson.height = height;
if (age >=65){
    newPerson.senior = true;
}
else {
    newPerson.senior = false;
}
    insertPerson(newPerson);
    creators.push (msg.sender);
    assert (
        keccak256 (
            abi.encodePacked (
                people[msg.sender].name, 
                people[msg.sender].age, 
                people[msg.sender].height, 
                people[msg.sender].senior)) 
                == 
        keccak256 (
            abi.encodePacked (
                newPerson.name, 
                newPerson.age, 
                newPerson.height, 
                newPerson.senior)));
emit personCreated (newPerson.name, newPerson.senior);
}

function insertPerson (Person memory newPerson) private{
    address creator = msg.sender;
    people[creator] = newPerson;
}

function getPerson () public view returns (string memory name, uint age, uint height, bool senior){
    address creator = msg.sender;
    return (people[creator].name, people[creator].age, people[creator].height, people[creator].senior);
}

function deletePerson (address creator) public onlyOwner {
    string memory name = people[creator].name;
    bool senior = people[creator].senior;
    delete people[creator];
    assert (people[creator].age ==0);
    emit personDeleted (name, senior, msg.sender);

}

function getCreator (uint index) public view onlyOwner returns (address){
    return creators[index];
}

}
