import "./Ownable.sol";
pragma solidity 0.6.6;
contract Destroyable is Ownable {
    
    
    function destroy() public onlyOwner {
    address payable receiver = msg.sender;
    selfdestruct(receiver);
}
}
