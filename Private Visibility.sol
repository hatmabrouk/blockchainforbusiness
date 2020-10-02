pragma solidity 0.6.6;
contract Identity {
    struct Person{
        string name;
        uint age;
        uint height;
        bool senior;
    }
    
    mapping (address=>Person) private people;
    
    function createPerson (string memory name, uint age, uint height) public{
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height= height;
        
        if(age>=65){
            newPerson.senior=true;
        }
        else {
            newPerson.senior = false;
        }
        insertPerson (newPerson);
        //here we need to call the insertPerson function to replace the functionality that we had here before.
    }
    
    function insertPerson (Person memory newPerson) private{
        address creator = msg.sender;
        people[creator] = newPerson;
    }
    
    function getperson () public view returns (string memory name, uint age, uint height, bool senior) {
        address creator = msg.sender;
        return (people[creator].name, people[creator].age, people[creator].height, people[creator].senior);
    }
}
