// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.15;

import "erc721a/contracts/ERC721A.sol";

contract Mock721 is ERC721A {
    constructor() ERC721A("","") {
        _mint(msg.sender,10);
    }

    function findOwnerOf(address addr,uint256 tokenId) external view returns(address) {
        
        assembly{
            mstore(0x0,0x6352211e)
            mstore(0x20,tokenId)
            if iszero(staticcall(gas(),addr,0x1c,0x24,0x0,0x0)) {
                revert(0x3,0x3)
            }
            return(0x0,0x20)

        }

    }

    function mint(address to,uint256 tokenId) external {
        _mint(to,tokenId);
    }
}