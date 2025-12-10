// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;
import {TNTERC20} from "../src/TNTERC20.sol";
import {Test} from "../lib/openzeppelin-contracts/lib/forge-std/src/Test.sol"; 
contract TNTERC20TEST is Test {
    TNTERC20 public token;
    address public devOpe=makeAddr ("devOpe");
    address public user=makeAddr("user");

    function setUp ()public {
        vm.prank(devOpe);
        token=new TNTERC20("TNTtoken","TNT",devOpe);
    }

    function testSetup() public view {
    assertEq(token.balanceOf(devOpe), 100 ether);
    assertEq(token.name(), "TNTtoken");
    assertEq(token.symbol(), "TNT");
    }
    
    function testName() public view {
        string memory name=token.name();
        assertEq (name,"TNTtoken");
    }
    function testSymbol()public view {
        string memory symbol=token.symbol();
        assertEq (symbol,"TNT");
    }
    function testDecimals() public view {
    uint8 decimal = token.decimals();
    assertEq(decimal, 18);
}


}