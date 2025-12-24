//SPDX-License-Identifier: MIT
pragma solidity 0.8.30;
// eip721- eip code your nft contract 
// Nft- non fungible token
import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "../lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import {Strings} from "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";
contract NFTCH4 is ERC721 {
    // error 
    error E_GuyYouVeMintedNow();

    // state variables
    string public NFTName;
    string public NFTSymbol;

    uint256 public lastTokenID;
    string public baseURL = 
    "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MDAiIGhlaWdodD0iNTAwIj4KICAgIDxyZWN0IHdpZHRoPSI1MDAiIGhlaWdodD0iNTAwIiBmaWxsPSIjMWExYTJlIi8+CiAgICA8dGV4dCB4PSI1MCUiIHk9IjQwJSIgdGV4dC1hbmNob3I9Im1pZGRsZSIgZm9udC1zaXplPSI2MCIgZmlsbD0iIzE2ZjRkMCIgZm9udC1mYW1pbHk9IkFyaWFsLCBzYW5zLXNlcmlmIiBmb250LXdlaWdodD0iYm9sZCI+VEVDSDwvdGV4dD4KICAgIDx0ZXh0IHg9IjUwJSIgeT0iNjAlIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBmb250LXNpemU9IjYwIiBmaWxsPSIjZjcyNTg1IiBmb250LWZhbWlseT0iQXJpYWwsIHNhbnMtc2VyaWYiIGZvbnQtd2VpZ2h0PSJib2xkIj5DUlVTSDwvdGV4dD4KPC9zdmc+Cg=="
    ;

    // string public baseURL = string(abi.encodePacked("data:image/svg+xml;base64,",Base64.encode('<svg width="400" height="400" xmlns="http://www.w3.org/2000/svg">'
    //     '<rect width="400" height="400" fill="#1a1a1a"/>'
    //     '<circle cx="200" cy="200" r="80" stroke="#00ff00" stroke-width="8" fill="#ffff00"/>'
    //     '<text x="200" y="350" font-family="Arial" font-size="24" fill="#ffffff" text-anchor="middle">Tech Crush NFT</text>'
    //     '</svg>')));

    // mappings
    mapping(address minter => bool hasMint )  public m_CheckMinters;
    mapping(uint256 id => string) public m_URIIdGetter;


    // constructors
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){
        NFTName = _name;
        NFTSymbol = _symbol;
    }

    function updateBaseURI(string memory uir) public {
        baseURL = uir;
    }
    function getBaseURI(uint256 _id) public view returns(string memory) {
        return m_URIIdGetter[_id];

    }

    function mintNFT(address _to) public {
            // checks
            // check that ade have minted before. 
        if( m_CheckMinters[_to] == true ) {
            revert E_GuyYouVeMintedNow();
        }
        // who is the last person id that minted?
        uint256 tokenID = lastTokenID;
        // add 1 to the last person that minted 
        uint256 currentMintingID = tokenID + 1;
        // mint to the added 1 + last person
        _mint(_to, currentMintingID );
        // set the minting address to true 
        m_CheckMinters[_to] = true;
    }

    function getMinter(address _to) public view returns(bool){
        return m_CheckMinters[_to];
    }

    function tokenURI(uint256 tokenID) public view override returns(string memory) {
        // 1. declare your metadata matadata 
        // 2. convert the tokenID to a string
        // 3 . get your baseURL to a base64 format 
        // 3a. conversion to picture - svg - base64
        // 3b. covert to svg anf the foundry coversion to base64 library
        string memory metadata = Base64.encode(
        abi.encodePacked(
            '{"name":"TECHCRUSHNFT #', 
                Strings.toString(tokenID),
                '","description":"This is a dedicated NFT for Tech Crush cohort",',
                '"image":"', baseURL, '",', 
                '"attributes":[{"trait_type":"Cohort","value":"Web3"}]',
                '}'
            )
        );

        // concatination 
        // ia the process of joining two or more string data to get 1 string in the end.
        // a + b + c = a b c ~ abi.encode 
        // a + b + c = abc ~ abi.encodePacked ab + c = abc ~ a + bc = abc ~ abc + 0 = abc
        //
        // dataurl this is what goes into your wallet.
        string memory dataURI = string( // convert to string
            abi.encodePacked("data:application/json;base64,", metadata)
            );
        return dataURI;
    }

function setUriId(uint256 id) public {
        string memory _tokenURI = tokenURI(id);
        m_URIIdGetter[id] = _tokenURI;
    }
}