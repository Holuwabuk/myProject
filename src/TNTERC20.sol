// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
contract TNTERC20 is ERC20 {
    
    string private TNTName;
    string private TNTSymbol;
    address private admin;

     constructor (string memory name,string memory symbol, address _admin) ERC20(name,symbol){
        TNTName=name;
        TNTSymbol=symbol;
        admin=_admin;
         _mint(msg.sender,100 ether);
        }
     
}