pragma solidity 0.6.6;
contract Identity{
    struct Person{
       
        string name;
        uint age;
        uint height;
        bool senior;
    }

    address public owner;
    //to save the owner of the address in a variable that will be used later.
    
    constructor () public {
       owner = msg.sender;
    }
    //time is important here:
    //you want the owner to be set automatically at the time of the contract creation 
    //and not to be modified later by anyone.
    
    //to the owner variable, we will assign the owner = msg.sender in the constructor 
    //because we want the message sender to be the owner (the one who initiated the contract creation).
    
    //Thus, this will allow us to set the owner automatically and once at the time of the contract creation 
    //by adding the owner to the constructor.
    
    
    mapping (address=>Person) private people;
    address [] private creators;
    //we need an address array called "creators" to check the addresses of the owners.
    // we are going to keep it private to be accessed by the owner;
    // now we need to create a getter fuction for it that will be public, but accessed only by the owner.
    
    function createPerson (string memory name, uint age, uint height) public{
       
        require (age<150, "age must be below 150");
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        if (age >=65){
            newPerson.senior = true;
        }
        else{
            newPerson.senior = false;
        }
        insertPerson(newPerson);
        //this adds the Person above that gets created to the mapping. How?
        //by exceuting the following function"insertPerson".
        
        creators.push (msg.sender);
        //this is to add addresses of the creators (message senders or the people interracting with the contract) 
        //to the array when the they create a Person.
        //In other words, this will add an entry into the array with the person that added Person.
        //P.S. msg.sender is defined under the next insertPerson function.
        
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
        // All of that is to assert that people[msg.sender] == newPerson.
        //Remember, newPerson when it gets created, it is associated with an address.
        //that you later on get with the "getCreator function".
        
        //"assert" makes sure that the addresses of the creators (message senders) within the mapping "people"
        //are equal to the Person data (newPerson) that gets created by them.
        
        //In other words, the hashing of the message senders addresses
        //should be equal to the hashing of the Person data they input.
        
        // You want to make sure that msg.sender = newPerson. Look at the next function for reference.
    } 
    
    function insertPerson (Person memory newPerson) private {
        address creator = msg.sender;
        //The address creator is the one who inputs the information.
        
        people [creator] = newPerson;
        //The creator key within the people mapping gives us the value of new added Person.
    }
    
    function getPerson () public view returns (string memory name, uint age, uint height, bool senior) {
        address creator = msg.sender;
        return (people[creator].name, people[creator].age, people[creator].height, people[creator].senior);
    }
    
    function deletePerson (address creator) public{ 
        // here we are trying to explain that we will delete a person by using the address of the creator.
        
        require (msg.sender == owner);
        //here we are trying to limit the delete function to the owner of the contract 
        //who used also the address of the creator.
        
        // as far as I understand the owner is the creator, but it the "require" error handling 
        //restricts our use to the term "owner", so we need to use the term "owner" for the "require" functionality.
        
        delete people [creator];
        //This is the how part:
        //this will delete the value from the mapping (people [creator]).
        
        assert(people[creator].age == 0);
        // all Person requirement, including age, shall be left as 0 after deleting.
        //In here we are asserting that the age requirement will be left as 0 after deleting Person.
    }
    
    function getCreator (uint index) public view returns (address) {
        require (msg.sender == owner, "caller must be owner");
        return creators [index];
        
    }
    
}
