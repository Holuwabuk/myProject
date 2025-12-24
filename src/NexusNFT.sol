// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";


contract NexusNFT is ERC721, ERC721Enumerable, Ownable { 
    uint256 maxSupply=100;
    uint256 private _tokenId;
    uint256 public constant allowListPrice=0.1 ether;
    uint256 public constant mintPrice=0.9 ether;
    bool public generalMintOpen =false;
    bool public allowListMintOpen = false;
    mapping (address=>bool) public allowList;


    constructor(address initialOwner) ERC721("NexusNFT", "Nex") Ownable(initialOwner) {

    }

    function setAllowListMint(address[]calldata addresses) public onlyOwner {
        for(uint256 i=0; i<addresses.length;i++){
            allowList[addresses[i]]=true;
        }
    }
     
     function editMintingState (bool genMinting,bool allowMinting)public onlyOwner{
        generalMintOpen = genMinting;  // Fixed: assignment was backwards
        allowListMintOpen = allowMinting;
     }

    function generalMint()public payable {
        require (msg.value >=0.9 ether, "broke man,get out");
        require (totalSupply() < maxSupply, "we are out of token");
        require (generalMintOpen, "generalMintOpen is closed");
        uint256 tokenId=_tokenId+1;
       _tokenId++;
        _safeMint(msg.sender,tokenId);
    }

    function allowedMint() public payable{
        require (allowList[msg.sender], "you are fucking off the list,brah");
        require (msg.value >= 0.1 ether, "broke man,get out");
        require (totalSupply() < maxSupply, "we are out of token");
        require (allowListMintOpen, "allowListMintOpen is closed");
        uint256 tokenId=_tokenId+1;
        _tokenId++;
        _safeMint(msg.sender,tokenId);
        
    }


function tokenURI(uint256 tokenId) public view override returns (string memory){
    if (ownerOf(tokenId) == address(0)) {
        revert("URI query for nonexistent token");
    } //you can use if or else,or even if revert

 string memory metadata = Base64.encode(abi.encodePacked(
    '{',
        '"name":"NexusNFT #', Strings.toString(tokenId), '",',
        '"description":"A futuristic cyberpunk NexusNFT.",',
        '"image":"https://ipfs.io/ipfs/bafybeidtjn57uec7earkgxnhbyupfdnjok2jecr5nsr5nw5q5ixvghk2hi",',
        '"attributes":[',
            '{"trait_type":"Theme","value":"Cyberpunk"},',
            '{"trait_type":"Energy","value":"Neon"},',
            '{"trait_type":"Rarity","value":"Legendary"}',
        ']',
    '}'
));

    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            metadata
        )
    );
}

function supportsInterface(bytes4 interfaceId)public view override(ERC721, ERC721Enumerable) returns (bool){
    return super.supportsInterface(interfaceId);
}
function _increaseBalance(address account, uint128 amount)
    internal
    override(ERC721, ERC721Enumerable)
{
    super._increaseBalance(account, amount);
}

function _update(address to, uint256 tokenId, address auth) internal override(ERC721, ERC721Enumerable) returns (address) {
    return super._update(to, tokenId, auth);
}

}