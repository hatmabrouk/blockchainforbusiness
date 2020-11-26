pragma solidity 0.6.6;

    // This part is for the interface (definition).
    interface HelloWorld {
    function createPerson (string calldata name, uint age, uint height) external payable;
    }
    
    //This part is for the location.
    contract ExternalContract {
    HelloWorld instance = HelloWorld (0x......................);
        //This statement: 1. creates a state variable of type "HelloWorld", which is defined in the interface up there. And
       //                 2. Specifies the location which is the address above.
       
    function externalCreatePerson (string memory name, uint age, uint height) public payable{
        // we need to call the createPerson function int he HelloWorld Contract.
        // We want to forward any Ether to the HelloWorld Contract because the createPerson function expects 1 Ether still
        // and we need to send that to this function when we call it and that needs to be forwarded to the HelloWorld contract to 
        // the createPerson function. That is why, we need the address by deploying the HelloWorld contract, which will give us
        // a contract address.
        
        // We can now use the instance created above to call the following function:
        
    instance.createPerson{value:msg.value} (name, age, height);    
        // the quick normal thing to do is usually instance.createPerson (name, age, height); but we also need
        // to forward the actual Ether that we got from "externalCreatePerson" into this function "instance.createPerson", 
        // so we need to have a "value" and in order to attach some Ether to this function call, we will attach 
        // :msg.value at the end. At this point, you can provide the arguments (name, age, height). 
        // This means you will have two function calls between {} and ().
    }
}
