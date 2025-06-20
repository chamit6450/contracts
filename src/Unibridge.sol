// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract unibridge is ERC20, Ownable{
   constructor(string memory name, string memory symbol, uint256 initialsupply) 
   ERC20(name, symbol)
   Ownable(msg.sender) 
   {
    _mint(msg.sender, initialsupply);
   }
   
   function mint(address to, uint256 amount) public onlyOwner{
    _mint(to,amount);
   }

   function burn(address to, uint256 amount) public onlyOwner{
    _burn(to, amount);
   }

}