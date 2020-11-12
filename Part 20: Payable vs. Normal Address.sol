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


modifier costs (uint cost){
    require (msg.value >= cost);
    _;
}

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


function createPerson (string memory name, uint age, uint height) public payable costs(1 ether) {
require (age < 150, "age must be less than 150");
balance+= msg.value;

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
    // There is a difference between address and address payable. 
    // address creator is a normal address.
    // msg.sender is an address of the person connecting with the contract by default in solidity.
    // In here, we assigned it the variable creator. so if we use creator.send() instead of
    // msg.sender.send(), we will get a compilation error because address creator is not a payable address.
    // And msg.sender has the capacity to become a payable by default.
    
    // A payable address is the one that sends and transfers. 
    //The reason solidity has this is to force the actual developer of the contract to rethink about which address shall 
    // send, receive or handle money to limit the amount of errors we do. 
    // If you want the creator address to send, then it is very easy 
    // because msg.sender can become a payable address. All you need is to add payable after address, like this for example:
    
    // address payable creator = msg.sender;
    // creator.send(10 ether); 
    
    // The hardest part is if you want a non-payable address to become a payable address, like this:
    // address payable test = creator; 
    // This is a case where we walk from a non-payable address (creator) to a payable address (test). 
    // The only way to make this possible is to cast the creator into a uint160(creator) and then you cast all
    // that to an address, like this;
    // address payable test = address (uint160(creator));
    
    // And that was how you go from a normal address to a payable address. 
    
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

function withdrawAll () public onlyOwner returns (uint) {
    uint toTransfer = balance;
    balance = 0;
    msg.sender.transfer (toTransfer);
    return toTransfer;
}

}
