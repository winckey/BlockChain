// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC721Connector.sol';


contract KryptoBird is ERC721Connector{


    string [] public kBirdz;
    //nft array
    mapping(string => bool) _kryptoBirdzExists;

    function mint(string memory _kryptoBird) public {

        require(!_kryptoBirdzExists[_kryptoBird],
        'Error - kryptoBird already exists');
        // this is deprecated - uint _id = KryptoBirdz.push(_kryptoBird);
        kBirdz.push(_kryptoBird);
        uint _id = kBirdz.length - 1;

        // .push no longer returns the length but a ref to the added element
        _mint(msg.sender, _id);
        //msg.sender 는 이걸 쓰는 사람의 주소
        // 여기서 잡는데 구지 다시하는이유가 머임???
        
        _kryptoBirdzExists[_kryptoBird] = true;

    }


    constructor()  ERC721Connector('kname2', 'ksymbol2') public {

    }


    
}


