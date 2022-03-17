// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;



    /*
    building out the minting function:
        a. nft to point to an address
        b. keep track of the token ids 
        c. keep track of token owner addresses to token ids
        d. keep track of how many tokens an owner address has
        e. create an event that emits a transfer log - contract address, 
         where it is being minted to, the id

    */

contract ERC721{
   

    event transfer(
        address indexed from ,
        address indexed to , 
        uint256 indexed tokenId);
    //cosole.log를 위한 이벤트
    //indexed 출력할때 마치 배열처럼 from이 들어온 순서대로 indexing되어 출력할수있게 해준다
    //emit 할때마다 저장됨 근데 어디?



    // mapping in solidity creates a hash table of key pair values
   
    // Mapping from token id to the owner
    mapping(uint256 => address) private _tokenOwner; 

    // Mapping from owner to number of owned tokens 
    mapping(address => uint) private _OwnedTokensCount;

    // Mapping from token id to approved addresses
    mapping(uint256 => address) private _tokenApprovals; 
    // 매핑이 바뀔경우 그것을 추적하여야 한다.


    // EXERCISE: 1. REGISTER THE INTERFACE FOR THE ERC721 contract so that it includes
    // the following functions: balanceOf, ownerOf, transferFrom
    // *note by register the interface: write the constructors with the 
    // according byte conversions

    // 2.REGISTER THE INTERFACE FOR THE ERC721Enumerable contract so that includes
    // totalSupply, tokenByIndex, tokenOfOwnerByIndex functions

    // 3.REGISTER THE INTERFACE FOR THE ERC721Metadata contract so that includes
    // name and the symbol functions


    constructor() public{
        // _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^
        // keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
    }

    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _owner The identifier for an NFT
    /// @return The address of the owner of the NFT// 이것들머임??
    // well we find the current balanceOf
        function balanceOf(address _owner) public  view returns(uint256) {
            require(_owner != address(0), 'owner query for non-existent token');
            return _OwnedTokensCount[_owner];
        }


    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT
    function ownerOf(uint256 _tokenId) public view returns (address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'owner query for non-existent token');
        return owner;
    }


    function _exists(uint256 tokenId) internal view returns(bool){
        // setting the address of nft owner to check the mapping
        // of the address from tokenOwner at the tokenId 
         address owner = _tokenOwner[tokenId];
         // return truthiness tha address is not zero
         //매핑에 해당값이 없다면 0을 리턴함
         //정확히는 0x00000000000을 리턴


         return owner != address(0);
    }

        // FINAL Library Exercise!
        // Refactor the ERC721 NFT Smart Contract to be 
        // wired into our SafeMath & Counters Library



    // this function is not safe 
    // any type of mathematics can be held to dubious standards 
    // in SOLIDITY 
    function _mint(address to, uint256 tokenId) internal virtual {
        //콜 주소와 콜 id를 받음
        //internal visibility추가
        //토큰id의 주소도 저근 할것임

        //토큰소유자 매핑을 여기로 가져오고 싶다

        // requires that the address isn't zero
        require(to != address(0), 'ERC721: minting to the zero addres');
        // 주소가 0일경우 에러 반환// ? 왜?

        // requires that the token does not already exist
        require(!_exists(tokenId), 'ERC721: token already minted');
        // we are adding a new address with a token id for minting
        //이미 있는경우 에러 반환
        
        _tokenOwner[tokenId] = to; 
        //토큰 소유자 매핑에 있는 이 토큰 아이디어는 실제로 주소와 동일하게 설정할 것입니다.
        //해당토큰id에 주인 주소 저장


        // keeping track of each address that is minting and adding one to the count
        //_OwnedTokensCount[to].increment();  
        _OwnedTokensCount[to] +=1; 
        //to가 가지고있는 토큰 카운트 증가!

       /* x = x + 1
        r = x + y, abs r >= x
        if x = 4 and y = 3 then r = 7
       abs r >= x
        r = x - y, abs y <= x
        */  
        emit transfer(address(0),to , tokenId);
        //보내는 사람은 아직없음
    }



    /// @notice Transfer ownership of an NFT 
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer

    // this is not safe! 
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), 'Error - ERC721 Transfer to the zero address');
        require(ownerOf(_tokenId) == _from, 'Trying to transfer a token the address does not own!');

        _OwnedTokensCount[_from] -=1;
        //전송자의 총갯수 감소
        _OwnedTokensCount[_to] +=1;
        // 받은사람갯수 하나 증가


        _tokenOwner[_tokenId] = _to;
        //저장하려는 토큰 id의 소유자의 주소 를 to로 변경

        emit transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);

    }

    // // 1. require that the person approving is the owner
    // // 2. we are approving an address to a token (tokenId)
    // // 3. require that we cant approve sending tokens of the owner to the owner (current caller)
    // // 4. update the map of the approval addresses

    // function approve(address _to, uint256 tokenId) public {
    //     address owner = ownerOf(tokenId);
    //     require(_to != owner, 'Error - approval to current owner');
    //     require(msg.sender == owner, 'Current caller is not the owner of the token');
    //     _tokenApprovals[tokenId] = _to;
    //     emit Approval(owner, _to, tokenId);
    // } 

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
        require(_exists(tokenId), 'token does not exist');
        address owner = ownerOf(tokenId);
        return(spender == owner); 
    }

}

