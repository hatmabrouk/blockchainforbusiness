pragma solidity 0.6.6;
contract Identity{
    
        //data location is where we tell solidity to save the data. 
        
        // There are three different data locations:
        
        //storage: everything that is saved permanently, like state and some local variables: 
        // mapping, structs, and arrays.
        //In our HelloWorld contract, the owner variable and the mapping data people[creator] are examples. 
        // They will all be in storage and live as long as the contract remains.
        
        //memory: It is saved only during a function execution, like the function input "string memory name".
        //this means the name will be kept and saved throughout the function execution,
        //until we reach the buttom of this function and its execution, then
        //the name as a parameter and argument for this function will be lost. 
        //That's why we initialize the newPerson variable locally
        //under the function. Then, we set all its properties, 
        //Then, we insert it into the mapping through insertPerson(newPerson) and people[creator] = newPerson 
        //because the mapping is by default in storage.
        //And that last step is the part when we save a copy of newPerson of the struct Person into the mapping.
        //so we do save the name, but we save it into our mapping.
        
        //stack: The stack memory usually sorts out itself. It is the least important of the three.
        //it is meant to hold local variables of value types, like uint, bool and variables that
        //are lower than 256 bits in size. The variables gets deleted here as well when the function is executed.
        //when it comes to the function arguments, 
        //they are always defauled to memory and you don't need to specify the data locations for them.
        // unlike strings, where you need to specify their data locations.
        //This explains why we don't type memory when we set them within the function.
        
    
    struct Person{
        string name;
        uint age;
        uint height;
        bool senior;
    }
    
    modifier onlyOwner () {
       require (msg.sender == owner);
        _;
    }
    
    address public owner;
    
    constructor () public{
        owner = msg.sender;
    }
    
    mapping (address => Person) private people;
    address [] private creators;

    function createPerson (string memory name, uint age, uint height) public{
        //
        require (age < 150, 'age must be less than 150');
        Person memory newPerson;
        // this means the instance of the struct Person will be deleted after the function execution.
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        if(age >= 65){
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
        delete people[creator];
        assert (people[creator].age == 0);
    }
    
    function getCreator (uint index) public view onlyOwner returns (address){
        return creators[index];
    }
    
}
