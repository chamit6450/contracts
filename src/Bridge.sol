// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IBUSDT is IERC20 {
    function mint(address _to, uint256 _amount) external;
    function burn(address _from, uint256 _amount) external;
}

contract Bridge is Ownable{
   uint256 public balance;
    address public tokenAddress;

    event Burn(address indexed burner, uint amount);

    mapping(address => uint256) public pendingBalance;

    constructor(address _tokenAddress) Ownable(msg.sender) {
        tokenAddress = _tokenAddress;
    }

     function mint(IBUSDT _tokenAddress, uint256 _amount) public {
        require(pendingBalance[msg.sender] >= _amount);
        pendingBalance[msg.sender] -= _amount;
        _tokenAddress.mint(msg.sender, _amount);
    }

   function burn(IBUSDT _tokenAddress, uint256 _amount) public {
        require(address(_tokenAddress) == tokenAddress);
        _tokenAddress.burn(msg.sender, _amount);
        emit Burn(msg.sender, _amount);
    }

     function burnedOnOppositeChain(address userAccount, uint256 _amount) public onlyOwner {
        pendingBalance[userAccount] += _amount;
    }
}