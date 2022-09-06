// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.7;
import "./ERC20-BIC.sol";

contract Bank{
    mapping (address => mapping(string => uint256)) _accountBalances;
    BlackIce _token;

    constructor(){
        _token = BlackIce(0x1c91347f2A44538ce62453BEBd9Aa907C662b4bD);
    }

    function withdraww(string memory tokenSymbol, uint256 amount) external payable returns(bool){
        address payable myAccount = payable(msg.sender); 
        require(myAccount != address(0), "Account is invalid");
        require(msg.value == amount);
        if (keccak256(bytes(tokenSymbol)) == keccak256(bytes("ETH"))){
            require(_accountBalances[myAccount]["ETH"] >= msg.value);
            myAccount.transfer(amount);
            //emit Transfer(address(this), myAccount, msg.value);

            _accountBalances[myAccount]["ETH"] = _accountBalances[myAccount]["ETH"] - amount;
        }
        if (keccak256(bytes(tokenSymbol)) == keccak256(bytes("BIC"))){
            require(_accountBalances[myAccount]["BIC"] >= msg.value);
            _token.transfer(myAccount, amount);

            _accountBalances[myAccount]["BIC"] = _accountBalances[myAccount]["BIC"] - amount;
        }
        return true;
    }

    function deposit(string memory tokenSymbol, uint256 amount) external payable returns(bool){
        address payable myAccount = payable(msg.sender);
        require(myAccount != address(0), "Account is invalid");
        require(msg.value == amount);
        if (keccak256(bytes(tokenSymbol)) == keccak256(bytes("ETH"))){
            payable(address(this)).transfer(msg.value);

            _accountBalances[myAccount]["ETH"] += msg.value;
        }
        if (keccak256(bytes(tokenSymbol)) == keccak256(bytes("BIC"))){

            _token.transferFrom(msg.sender, address(this), amount);

            _accountBalances[myAccount]["BIC"] += msg.value;
        }
        return true;
    }

    function transfer(string memory tokenSymbol, address payable to, uint256 amount) external payable returns(bool){
        address payable myAccount = payable(msg.sender);
        require(myAccount != address(0), "Account(From) is invalid");
        require(to != address(0), "Account(To) is invalid");
        require(msg.value == amount);
        if (keccak256(bytes(tokenSymbol)) == keccak256(bytes("ETH"))){
            require(_accountBalances[myAccount]["ETH"] >= msg.value);

            payable(address(this)).transfer(msg.value);
            to.transfer(msg.value);

            _accountBalances[myAccount]["ETH"] = _accountBalances[myAccount]["ETH"] - msg.value;
            _accountBalances[to]["ETH"] += msg.value;
        }
        if (keccak256(bytes(tokenSymbol)) == keccak256(bytes("BIC"))){
            require(_accountBalances[myAccount]["BIC"] >= msg.value);

            _token.transferFrom(msg.sender, to, msg.value);

            _accountBalances[myAccount]["BIC"] = _accountBalances[myAccount]["BIC"] - msg.value;
            _accountBalances[to]["BIC"] += msg.value;
        }
        
        return true;
    }

    function showBalance() external view returns(uint, uint){
        address myAddr = msg.sender;
        return (_accountBalances[myAddr]["ETH"], _accountBalances[myAddr]["BIC"]);
    }


    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}
}
