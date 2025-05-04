// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BaseBridge is Ownable{
    address public tokenAddress;
    uint256 public amount;
    event Deposit(address indexed depositor, uint256 amount);
    constructor(address _tokenAddress) Ownable(msg.sender){
      tokenAddress = _tokenAddress;
    }
    
    mapping (address => uint256) public pendingBalance;

    function deposit(IERC20 _tokenAddress, uint256 _amount) public onlyOwner{
      require(address(_tokenAddress) == tokenAddress);
      require(_tokenAddress.allowance(msg.sender, address(this)) >= _amount);
      require(_tokenAddress.transferFrom(msg.sender, address(this), _amount));
      emit Deposit(msg.sender, _amount);
    }

    function withdraw(IERC20 _tokenAddress, uint256 _amount) public onlyOwner{
        require(pendingBalance[msg.sender] >= _amount);
        pendingBalance[msg.sender]-=amount;
        _tokenAddress.transfer(msg.sender, _amount);
    }

    function burnedOnOppositeChain(address userAccount, uint256 _amount) public onlyOwner {
        pendingBalance[userAccount] += _amount;
    }
}