pragma solidity 0.6.6;
contract HelloWorld {
    struct Person{
        string name;
        uint age;
        uint height;
        bool senior;
    }
    
    event personCreated (string name, bool senior);
    event personDeleted (string name, bool senior, address deletedBy);
    
    uint public balance;
    address public owner;
    
    modifier onlyOwner (){
        require (msg.sender == owner); 
        _; 
    }
    
    modifier costs (uint cost){
    require (msg.value >= cost);
        _;
    }
    
    constructor () public{
        owner = msg.sender;
    }
    
    mapping (address =>Person) private people;
    address [] private creators;
    
    function createPerson (string memory name, uint age, uint height) public payable costs (1 ether) {
        require (age<150, "age must be below 150");
        balance += msg.value;
        
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        if(age >=65) {
            newPerson.senior = true;
        }
        else {
            newPerson.senior = false;
        }
        insertPerson (newPerson);
        creators.push (msg.sender);
        assert (
            keccak256 (
                abi.encodePacked (
                    people[msg.sender].name, 
                    people[msg.sender].age, 
                    people[msg.sender].height, 
                    people[msg.sender].senior
                )
            ) 
            == 
            keccak256 (
                abi.encodePacked (
                    newPerson.name, 
                    newPerson.age, 
                    newPerson.height, 
                    newPerson.senior
                )
            )
        );
        
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
        assert (people[creator].age == 0);
        emit personDeleted (name, senior, msg.sender);
        
    }
    
    function getCreator (uint index) public view onlyOwner returns (address){
        return creators[index];
    }

    function withdrawAll () public onlyOwner returns (uint){
        uint toTransfer = balance; // This is the balance inside the wallet.
        balance = 0; // this is the balance displayed after withdrawing the money.
        if (msg.sender.send (toTransfer)){
        return toTransfer; // the owner receives the balance inside the wallet.
    }
    else {
        balance = toTransfer; // the balance displayed is the balance inside the wallet with no changes.
        return 0; // the owner receives nothing (zero)
    }
        
    }

}
