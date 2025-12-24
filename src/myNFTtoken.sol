// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.5.0
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFTtoken is ERC721, ERC721Enumerable, Ownable {

    uint256 maxSupply=50;
    uint256 private _tokenId;
    uint256 public constant MINT_PRICE = 5 ether;
    uint256 public constant ALLOWLIST_PRICE = 3 ether;
    bool allowListMintOpen=false;
    bool publicMintOpen=false;
    mapping (address=>bool) public allowList;

    constructor (address initialOwner) ERC721("MyNFTtoken", "MNT") Ownable(initialOwner){
        }

//function to edit the state of both public and allowListMint
    function editMintingState(bool _allowListMint, bool _publicMint) external onlyOwner {
        allowListMintOpen=_allowListMint;
        publicMintOpen= _publicMint;
}
// to make it able to recieve funds and also remove onlyOwner,so public can mint
    function safeMint() public payable {
        require (publicMintOpen,"publicMintClosed");
        require (msg.value==5 ether, "insufficient funds");
        require (totalSupply() < maxSupply, "We Ran Out of Token");
         uint256 tokenId = _tokenId + 1; // starts from 1,for 0,not +1
         _tokenId++;
        _safeMint(msg.sender, tokenId);
    }
//function to set the allowed folks by only the owner/populate the allowList
// The array (address[] calldata addresses):Is just a temporary list you pass into the functionLets you submit multiple addresses at onceDisappears after the function runs (it's just input data)
    function setAllowList(address [] calldata addresses) public onlyOwner{  //this is hardcoding;you can add bool status as another parameter,but you wont =true but to status
        for(uint256 i=0;i<addresses.length;i++){         //forloop,allows for multiple calling of the execution,next code line
        allowList[addresses[i]]=true;
        } 
    }
//create an allowlist for lower amount
    function allowListMinting ()public payable{
        require (allowListMintOpen, "allowListMint closed");
        require (allowList[msg.sender], "you are not on the fucking list!");
        require (msg.value== 3 ether, "insufficient funds");
        require (totalSupply () <maxSupply,"we ran out of token");
        uint tokenId=_tokenId+1;
        _tokenId++;
        _safeMint(msg.sender,tokenId);

    }

    // in both public and allowListMint,some enteries are basically similar,they both share them in commom;you can clan up by putting them in a function as shown;
    function internalMint() internal{
         require (totalSupply () <maxSupply,"we ran out of token");
        uint tokenId=_tokenId+1;
        _tokenId++;
        _safeMint(msg.sender,tokenId);
    } //you can then delete them and replace with internalMint();

//when minted,the money goes to the contract,theres a need to have a withdraw function
    function withdraw (address _addr) external onlyOwner {
        //first get the balance
        uint256 bal=address(this).balance;
        payable(_addr).transfer(bal);
    }


     function _baseURI() internal pure override returns (string memory) {
        return "jjf";
    }


    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}