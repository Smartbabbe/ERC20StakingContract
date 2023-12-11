// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {
    event Staked(address indexed staker, uint256 indexed amount);
    event Withdrawn(address indexed staker, uint256 indexed amount);

    IERC20 public token;
    address public owner;


     mapping (address => uint256) public stakedAmount;

     constructor (address _token) {
        owner = msg.sender;
        token = IERC20(_token);
     }

     function stake(uint256 _amount) external {
        require (_amount > 0, "Can't donate zero value");

        token.transferFrom(msg.sender, address(this), _amount);

        stakedAmount[msg.sender] += _amount;

        emit Staked(msg.sender, _amount);
    }

    function withdraw(uint256 _amount) external  {
        require(msg.sender == owner);
        require(_amount > 0, "Amount must be greater than 0");
        require(stakedAmount[msg.sender] >= _amount, "Insufficient balance");

        stakedAmount[msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);

        emit Withdrawn(msg.sender, _amount);
    }

    function getStakedBalance () external view returns (uint256) {
        return stakedAmount[msg.sender];
    }

}

