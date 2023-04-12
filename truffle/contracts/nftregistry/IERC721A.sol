// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../../node_modules/erc721a/contracts/IERC721A.sol";
import "./LegalContractNFT.sol";

interface IERC721Ac is IERC721A {
    function safeMint(address to, uint quantity, bytes32[] calldata merkleProof, bytes memory _data) external;

    function setMerkleRoot(bytes32 merkleRoot) external;

    function setBaseURI(string memory baseURI) external;

    function setTokenURI(string memory tokenURI) external;

    function tokenURI(uint256 _tokenId) external view override returns(string memory);

    function burn(uint256) external;

    function assignRoleOfParties(uint32 roleNumber) external;

    function beginPartiesIdentification(address partyAddr) external;

    function beginPartiesAwareness() external;

    function partyAwareness(address partyAddr) external;

    function transferOwnership(address newOwner) external;
}