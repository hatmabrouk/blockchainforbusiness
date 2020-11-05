pragma solidity 0.6.6;
contract Identity {
    struct Person{
        string name;
        uint age;
        uint height;
        bool senior;
    }
    
    event personCreated (string name, bool senior);
    event personDeleted (string name, bool senior, address deletedBy);
    
    address public owner;
    
    modifier onlyOwner (){
        //the modifier name is onlyOwner because we want to restrict some functions to use of the owner only.
        require (msg.sender == owner); 
        // here we just moved the require function to here instead of under the delete and getCreator functions. 
        _; 
        //this means continue the execution. 
    }
    
    constructor () public{
        owner = msg.sender;
    }
    
    mapping (address =>Person) private people;
    address [] private creators;
    
    function createPerson (string memory name, uint age, uint height) public{
        require (age<150, "age must be below 150");
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
        //here we tried to save the data locally first before getting deleted.
        // because this data will be used to reflect a personDeleted event.
        
        delete people[creator];
        assert (people[creator].age == 0);
        emit personDeleted (name, senior, msg.sender);
    }
    
    function getCreator (uint index) public view onlyOwner returns (address){
        return creators[index];
    }
    
}
