pragma solidity 0.5.1;
contract MemoryAndStorage {

    mapping(uint => User) users;

    struct User{
        uint id;
        uint balance;
    }

    function addUser(uint id, uint balance) public {
        users[id] = User(id, balance);
        //whether you choose id or balance within the users mapping the result and values are the same.
        //we probably prioritized the id because under the getBalance function, you get the balance using the id.
    }

    function updateBalance(uint id, uint balance) public {
        User memory user = users[id];
        user.balance = balance;
    }

    function getBalance(uint id) view public returns (uint) {
        return users[id].balance;
    }

}
