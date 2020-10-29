pragma solidity 0.5.1;
contract MemoryAndStorage {

    mapping(uint => User) users;

    struct User{
        uint id;
        uint balance;
    }

    function addUser(uint id, uint balance) public {
        users[id] = User(id, balance);
    }

    function updateBalance(uint id, uint balance) public {
     users[id].balance = balance;
    }
        // a user (with small u) is new information. It is defined by referring to the User struct saved in the storage.
        // Thus, it consists of an id and a balance. Therefore, the user id and balance must be explained. 
        // This user is going to have an id within the users mapping. so no changes to the id.
        // The id within the struct and the users mapping, is getting stored within the User memory variable . . . or storage?
        
        // what about the balance?
        
        // The problem we have here is that we tried to store the id of the mapping users
        // within a user memory variable. And then, we went and modified that user memory variable 
        // and changed its balance, as explained below. Consequently, user became a local variable stored in memory. 
        
        //If you want to store the id of the mapping users within a variable, the easiest solution is 
        // to change memory to storage. This will allow the local variable user 
        // to be a direct pointer to the User that is in the mapping value.
        
        // Another way to solve the problem is to have users[id].balance = balance. 
        // In here, you are not storing the id of the mapping users in a variable that needs reference.
        // same like before when we did people[creator] = newPerson;
        // That is the same thing as the first solution, but accomplished in one line.
        // This is because the mapping users is added to storage automatically, so there is no need to mention 
        
    function getBalance(uint id) view public returns (uint) {
        return users[id].balance;
    }

}
