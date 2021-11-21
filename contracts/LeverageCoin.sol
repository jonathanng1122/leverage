// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./IERC20.sol";

contract LeverageCoin {
    struct Account {
        uint256 balance;
        uint256 debt;
        uint256 collateral;
        mapping(address => uint256) allowances; // spender => amount // this Account is allowing this spender to have x amount
    }

    mapping(address => Account) public accounts;

    uint256 _totalSupply = 1000000; 

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // constructor() public {

    // }

    modifier enoughBalance(uint256 amount) {
      require(accounts[msg.sender].balance >= amount, "msg.sender does not have enough balance");
      _;
    }

    function totalSupply() external view returns (uint256) {
      return _totalSupply;
    }
    function balanceOf(address account) external view returns (uint256) {
      return accounts[account].balance;
    }
    function allowance(address owner, address spender) external view returns (uint256) {
      return accounts[owner].allowances[spender];
    }

    function transfer(address recipient, uint256 amount) external enoughBalance(amount) returns (bool) {
      accounts[msg.sender].balance -= amount;
      accounts[recipient].balance += amount;
      emit Transfer(msg.sender, recipient, amount);
      return true;
    }
    
    function approve(address spender, uint256 amount) external enoughBalance(amount) returns (bool) {
      accounts[msg.sender].allowances[spender] = amount;
      return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
      uint _allowance = accounts[sender].allowances[recipient];
      require(msg.sender == sender || _allowance >= amount);

      _allowance -= amount;
      accounts[recipient].balance += amount;
      return true;
    }

}
