// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../../node_modules/erc721a/contracts/IERC721A.sol";
import "./Airdrop.sol";

interface IAirdropRegistrar {
    function getTokenId() external returns (address);

    function createAirdropRegistrar(uint256 tokenId) external returns(AirdropRegistrar);

    function transferAirdropOwnership(address newOwner) external;

    function transferNFTOwnership(address nftAddr, address newOwner) external;

    function registerLawfirmSubdomain(bytes32[] calldata merkleProof, bytes32 merkleRoot, bytes32 subNode, bytes calldata data) external;

    function addToWhiteList(address whiteListed) external;

    function requestOriginalCopy(bytes32[] calldata merkleProof, bytes32 merkleRoot, bytes32 subNode, bytes calldata data) external;
}