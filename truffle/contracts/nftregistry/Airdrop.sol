// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "../../node_modules/@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "../../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "./IERC721A.sol";
import "./LegalContractNFT.sol";

contract AirdropRegistrar is Ownable {
    address public immutable token;
    bytes32 public immutable merkleRoot;

    address public deployedNFTAddr;

    mapping(address => bool) public claimed;

    event Registered(bytes32 subNode);
    event OriginalCopyIssued(address indexed claimer, bytes32 subNode);

    constructor(address _token) {
        token = _token;
        merkleRoot = bytes32(abi.encodePacked("_merkleRoot"));
    }

    function getToken() 
    external
    view
    onlyOwner
    returns (address) {
        return token;
    }

    function transferAirdropOwnership(address _newOwner) 
    external 
    onlyOwner {
        transferOwnership(_newOwner);
    }

    function transferNFTOwnership(address _nftAddr, address _newOwner) 
    public {
        IERC721Ac(_nftAddr).transferOwnership(_newOwner);
    }

    function registerLawfirmSubdomain(
        bytes32[] calldata _merkleProof,
        bytes32 _merkleRoot,
        bytes32 _subNode,
        bytes calldata _data
    ) 
    external 
    onlyOwner {
        // require(
        //     canClaim(msg.sender, _merkleProof),
        //     "Registrar: Address is not a candidate for registration"
        // );

        claimed[msg.sender] = true;

        IERC721Ac(token).safeMint(
            msg.sender, 
            1, 
            _merkleProof,
            _merkleRoot,
            _data
        );
        emit Registered(_subNode);
    }

    // function addToWhiteList(address) external {}

    // function attachLumpContract(
    //     bytes32[] calldata _merkleProof, 
    // )
    // external
    // onlyOwner  {
    //     require(
    //         canClaim(msg.sender, _merkleProof),
    //         "Registrar: Address is not a candidate for registration"
    //     );

    //     IERC721c(token).setTokenURI();
    // }

    // function requestOriginalCopy(
    //     bytes32[] calldata _merkleProof,
    //     bytes32 _merkleRoot,
    //     bytes32 _subNode, 
    //     bytes calldata _data
    // ) 
    // external {
    //     require(
    //         canClaim(msg.sender, _merkleProof),
    //         "Airdrop: Address is not a candidate for claim"
    //     );

    //     claimed[msg.sender] = true;

    //     IERC721Ac(token).safeMint(
    //         msg.sender,
    //         1,
    //         _merkleProof,
    //         _merkleRoot,
    //         _data
    //     );

    //     emit OriginalCopyIssued(msg.sender, _subNode);
    // }

    function canClaim(address claimer, bytes32[] calldata merkleProof)
    public
    view
    returns (bool) {
        return 
            !claimed[claimer] &&
            MerkleProof.verify(
                merkleProof,
                merkleRoot,
                keccak256(abi.encodePacked(claimer)
            )
        );
    }

    function resetClaim(address claimer)
    external {
        require(claimed[claimer], "Unrecognised address");
        claimed[claimer] = false;
    }
}