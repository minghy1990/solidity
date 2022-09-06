// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.7;
import "./IERC20.sol";

contract BlackIce is IERC20{
    mapping(address => uint256) private _balance;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimal;

    constructor(){
        _name = "BlackIcm";
        _symbol = "BIC";
        _decimal = 1;
    }

    function decimals() external view override returns (uint8) {
        return _decimal;
    }

    function totalSupply() external view override returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address account) external view override returns (uint256){
        return _balance[account];
    }

    function transfer(address to, uint256 amount) external override returns (bool){
        address from = msg.sender;
        _transfer(from, to, amount);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint256){
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external override returns (bool){
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external override returns (bool){
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal virtual{
        require(from != address(0), "ERC20: transfer from the ZERO address");
        require(to != address(0), "ERC20: transfer from the ZERO address");

        _beforeTokenTransfer(from, to, amount);

        require(_balance[from] >= amount, "ERC20: transfer amount exceeds balance");
        unchecked{
            _balance[from] = _balance[from] - amount;
            _balance[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual{
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            _balance[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balance[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balance[account] = accountBalance - amount;
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual{
        uint256 currentAllowance = _allowances[owner][spender];
        if(currentAllowance != type(uint256).max){
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked{
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    function mint(uint256 amount) external returns(bool){
        address acct = msg.sender;
        _mint(acct, amount); 
        return true;
    }
}
