//SPDX-License-Identifier:MIT
pragma solidity 0.8.30;
import {Test} from "../lib/forge-std/src/Test.sol";
import {NexusNFT} from "../src/NexusNFT.sol";

contract NexusNFTTest is Test {
NexusNFT public _NexusNFT;
address public owner=makeAddr("owner");
address public user1=makeAddr("user1");
address public user2=makeAddr("user2");

function setUp() public {
    _NexusNFT = new NexusNFT(owner); //Prank is redundant here, because ownership is explicitly set.
    //owner served as the initialOwner in the constructor. if there were name,symbol and initialOwner,all three would be entered
    vm.deal(user1, 5 ether);
    vm.deal(user2, 5 ether);
}
function testNameSymbolAndOwner()public view {
    assertEq(_NexusNFT.name(),"NexusNFT");
    assertEq(_NexusNFT.symbol(),"Nex");
    assertEq(_NexusNFT.owner(),owner);
}
 function testSetAllowList() public {
        address[] memory addresses = new address[](2); //This just allocates temporary memory for an array. No deployment, no blockchain, just RAM.
        addresses[0] = user1;
        addresses[1] = user2;

        vm.prank(owner);
        _NexusNFT.setAllowListMint(addresses);
        
        assertTrue(_NexusNFT.allowList(user1));
        assertTrue(_NexusNFT.allowList(user2));
 }
function testEditMintingState () public {   //1: “When the owner calls it, does the function actually do what it claims?”
        vm.prank(owner);
        _NexusNFT.editMintingState(true, true);
        assertTrue(_NexusNFT.generalMintOpen());
        assertTrue(_NexusNFT.allowListMintOpen());
        
        vm.prank(owner);
        _NexusNFT.editMintingState(false, false);
        assertFalse(_NexusNFT.generalMintOpen());
        assertFalse(_NexusNFT.allowListMintOpen());
}
 function testEditMintingStateOnlyOwner() public {  //2
        vm.prank(user1);
        vm.expectRevert();
        _NexusNFT.editMintingState(true, true);
    }
function testGeneralMint() public {
    vm.prank(owner);
    _NexusNFT.editMintingState(true, false); //to edit the state

    vm.prank(user1);
    _NexusNFT.generalMint{value: 0.9 ether}();
        
    vm.prank(user2);
    _NexusNFT.generalMint{value: 0.9 ether}();
        
    assertEq(_NexusNFT.balanceOf(user1), 1); //how many NFT minted by user1
    assertEq(_NexusNFT.balanceOf(user2), 1); //how many NFT minted by user2
    assertEq(_NexusNFT.ownerOf(1), user1);
    assertEq(_NexusNFT.ownerOf(2), user2); //ownerOf returns the current owner of a specific NFT ID.
    assertEq(_NexusNFT.totalSupply(), 2);
}
 function testAllowedMint()public {
    // Need to declare AND create the array
    address[] memory users = new address[](2);
    users[0] = user1;
    users[1] = user2;
      vm.prank(owner);
    _NexusNFT.setAllowListMint(users); // i can use addresses  instead,as used above  address[] memory addresses = new address[](2); //This just allocates temporary memory for an array. No deployment, no blockchain, just RAM. addresses[0] = user1; addresses[1] = user2

    vm.prank(owner);
    _NexusNFT.editMintingState(false,true);

    vm.prank(user1);
    _NexusNFT.allowedMint{value:0.1 ether}();

    vm.prank(user2);
    _NexusNFT.allowedMint{value : 0.1 ether}();

    assertEq(_NexusNFT.balanceOf(user1), 1); //how many NFT minted by user1
    assertEq(_NexusNFT.balanceOf(user2), 1); //how many NFT minted by user2
    assertEq(_NexusNFT.ownerOf(1), user1);
    assertEq(_NexusNFT.ownerOf(2), user2); //ownerOf returns the current owner of a specific NFT ID.
    assertEq(_NexusNFT.totalSupply(), 2);
 }

 
    function testTokenURI() public {
    // 1️⃣ Enable general minting
    vm.prank(owner);
    _NexusNFT.editMintingState(true, false);

    // 2️⃣ Mint a token for user1
    vm.prank(user1);
    _NexusNFT.generalMint{value: 0.9 ether}();

    // 3️⃣ Get the tokenURI
    string memory uri = _NexusNFT.tokenURI(1);

    // 4️⃣ Assert it’s not empty
    assertTrue(bytes(uri).length > 0);

    // 5️⃣ Check prefix without using substring
    bytes memory uriBytes = bytes(uri);
    bytes memory prefix = new bytes(29);

    for (uint256 i = 0; i < 29; i++) {
        prefix[i] = uriBytes[i];
    }

    assertEq(string(prefix), "data:application/json;base64,");

}

    function testTokenURINonexistent() public {
    // Expect revert because token 999 does not exist
    vm.expectRevert();
    _NexusNFT.tokenURI(999);
}

}













