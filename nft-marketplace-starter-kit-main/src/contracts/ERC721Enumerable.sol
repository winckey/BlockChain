// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


import './ERC721.sol';


contract ERC721Enumerable is  ERC721 {

    uint256[] private _allTokens;

    // mapping from tokenId to position in _allTokens array
        mapping(uint256 => uint256) private _allTokensIndex;

    // mapping of owner to list of all owner token ids
        mapping(address => uint256[]) private _ownedTokens;

    // mapping from token ID to index of the owner tokens list 
        mapping(uint256 => uint256) private _ownedTokensIndex;

    
    constructor() public{
      
    }

    function _mint(address to, uint256 tokenId) internal override(ERC721) {// 객체지향적인 코딩
        super._mint(to, tokenId);//상위 함수 호출
        //mint = 토큰을 추가하고 소유자에게 그 토큰을 추가
        // 2 things! A. add tokens to the owner
        // B. all tokens to our totalsuppy - to allTokens
        // 모든 토큰을 관리한다.

        //토큰을 mint 하고 관리한다.
        _addTokensToTotalSupply(tokenId); 
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    // add tokens to the _alltokens array and set the position of the tokens indexes
    function _addTokensToTotalSupply(uint256 tokenId) private {
        //mint에서 호출에서 저장할것임

        _allTokensIndex[tokenId] = _allTokens.length;
        //해당토큰이 몇번째 토큰?
        _allTokens.push(tokenId);
        //토큰을 배열에 저장 
    }

    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        // EXERCISE - CHALLENGE - DO THESE THREE THINGS:
        // 1. add address and token id to the _ownedTokens
        // 2. ownedTokensIndex tokenId set to address of 
        // ownedTokens position
        // 3. we want to execute the function with minting
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);   
    }

    // two functions - one that returns tokenByIndex and 
    // another one that returns tokenOfOwnerByIndex
    // function tokenByIndex(uint256 index) public override view returns(uint256) {
    //     // make sure that the index is not out of bounds of the total supply 
    //     require(index < totalSupply(), 'global index is out of bounds!');
    //     return _allTokens[index];
    // }

    // function tokenOfOwnerByIndex(address owner, uint index) public override view returns(uint256) {
    //     require(index < balanceOf(owner),'owner index is out of bounds!');
    //     return _ownedTokens[owner][index];  
    // }

    // return the total supply of the _allTokens array
    function totalSupply() public view returns(uint256) {
        return _allTokens.length;
    }

}