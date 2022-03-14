// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


contract ERC721Metadata{

    string private _name;
    string private _symbol;
    //이정보를 kbird 생성자에게 넘길꺼임

    constructor (string memory named, string memory symbolified)  public  {
        // string 은 변수로받을때 memory로 받아야한다.
        _name = named;
        _symbol = symbolified;
        
    }

    function name() external view returns(string memory) {
        // extrtnal 외부 컨트렉트에서 접근가능한
        // view 정보 제공만을할때 명시하는 키워드
        return _name;
    }

    function symbol() external view returns(string memory) {
    return _symbol;
    }

}