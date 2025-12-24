// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;
import {Test} from "../lib/forge-std/src/Test.sol";
import {NFTCH4} from "../src/NFTCH4.sol";

contract testNFTCH4 is Test {
    // declare the NFTCH4 contract a data type 
    NFTCH4 public s_NFTCH4; 

    // hamid 
    address public hamid = makeAddr("hAMID");
    // kenechukwu
    address public kenechukwu = makeAddr("ken");
    // mattew 
    address public mattew = makeAddr("mattew");
    function setUp() public {
        vm.startPrank(kenechukwu);
        s_NFTCH4 = new NFTCH4("TECHCRUSH", "TCH");
        vm.stopPrank();
    }

    function testName() public view {
        string memory expectedName = s_NFTCH4.NFTName();
        string memory actualName = "TECHCRUSH";

        assertEq(expectedName, actualName);
        // is a == b? if a == b---- pass it if not fail 
    }
    
    function testSymbol() public view {
        string memory expectedsymbol = s_NFTCH4.NFTSymbol();
        string memory actualSymbol = "TCH";

        assertEq(expectedsymbol, actualSymbol);
    }

    function testMint() public {
        vm.prank(hamid);
        s_NFTCH4.mintNFT(hamid);

        bool hasMint = s_NFTCH4.getMinter(hamid);

        assertEq(hasMint, true);
    }

    // 1 001
    // 002 
    // 003   123 = 001002003
    // a  0027
    // b 

    function testTokenURI() public {
        // prank that mattew is calling the nft contract
        vm.prank(mattew);
        // mint an nft to mattew address _to addr
        s_NFTCH4.mintNFT(mattew);

        // set mattew id to mattew nft(in string)
        s_NFTCH4.setUriId(1);
        // get the mattew nft(in string ) using the id
        string memory mattewNFT = s_NFTCH4.getBaseURI(1);
        // comapre the string is more than zero

        uint256 bytesLength = bytes(mattewNFT).length;
        // asseert compares 2 values if a is greater than b
        assertTrue(bytesLength > 0);
    }
    // forge test --match-test testTokenURI -vvvvvv
}