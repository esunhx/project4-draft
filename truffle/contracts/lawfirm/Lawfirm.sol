// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//@author Ascanio Macchi di Cellere

import "../../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../../node_modules/@ensdomains/ens-contracts/contracts/registry/ENSRegistry.sol";
import "../../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "../nftregistry/IAirdrop.sol";
import "../nftregistry/Airdrop.sol";
import "../nftregistry/IERC721A.sol";
import "../nftregistry/LegalContractNFT.sol";

contract Lawfirm is Ownable, ENSRegistry {
    bytes32 public immutable lawfirmNode;
    string public lawfirmName;

    ENS internal immutable ens = ENS(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e);
    ENS lawfirmENS;
    AirdropRegistrar registrar;
    LegalContractNFT legalContract;
    
    constructor(address _foundingPartner, string memory _lawfirmName) payable {
        legalMembers[_foundingPartner].isActive = true;
        legalMembers[_foundingPartner].isPartner = true;
        lawfirmName = _lawfirmName;
        lawfirmNode = bytes32(abi.encode(string.concat(_lawfirmName, ".eth")));
        lawfirmENS = ENS(address(uint160(uint256(lawfirmNode))));
    }

    struct LegalStaff {
        bool isActive;
        bool isPartner;
        bool isAssociate;
        bool isParalegal;
        mapping (address => bytes32) legalContracts;
        mapping (address => uint) clients; 
    }

    mapping (address => LegalStaff) public legalMembers;
    mapping (uint256 => address) public registrars;

    event LegalStaffRegistered(address legalMemberAddr);
    event PartnerMintedLegalContract(address partnerAddr, bytes32 contractTonkenId);

    modifier onlyPartner() {
        require(
            legalMembers[msg.sender].isPartner && legalMembers[msg.sender].isActive, 
            "Unknown address for Partner"
        );
        _;
    }

    modifier onlyLegalStaff() {
        require(
            legalMembers[msg.sender].isPartner || 
            legalMembers[msg.sender].isParalegal || 
            legalMembers[msg.sender].isAssociate &&
            legalMembers[msg.sender].isActive,
            "Unknown address for LegalStaff"
        );
        _;
    }

    function transferLawfirmOwnership(address _newOwner)
    external 
    onlyOwner {
        transferOwnership(_newOwner);
    }

    function transferAirdropOwnership(address _registrarAddr, address _newOwner) 
    internal 
    onlyOwner {
        IAirdropRegistrar(_registrarAddr).transferAirdropOwnership(_newOwner);
    }

    function lawfirmAddr() external view returns (address) {
        return address(this);
    }

    function registerLegalStaff(address _addr, uint8 _status) 
    public 
    onlyPartner {
        require(legalMembers[_addr].isActive == false, "Address already in use");
        require(_status == 1 || _status == 2 || _status == 3, "Wrong status operator");
        legalMembers[_addr].isActive = true;
        if (_status==1) legalMembers[_addr].isPartner == true;
        if (_status==2) legalMembers[_addr].isAssociate == true;
        if (_status==3) legalMembers[_addr].isParalegal == true;

        emit LegalStaffRegistered(_addr);
    }

    function removeLegalStaff(address _addr)
    public
    onlyPartner {
        require(legalMembers[_addr].isActive == true, "Address already inactive");
        legalMembers[_addr].isActive = false;
    }

    function isWhiteListed(address _userAddr, bytes32 _merkleRoot, bytes32[] calldata _merkleProof) 
    internal 
    pure 
    returns (bool) {
        return _verify(leaf(_userAddr), _merkleRoot, _merkleProof);
    }

    function leaf(address partyAddr) 
    internal
    pure 
    returns (bytes32){
        return (keccak256(abi.encodePacked(partyAddr)));
    }

    function _verify(bytes32 _leaf, bytes32 _merkleRoot, bytes32[] memory _merkleProof) 
    pure
    internal 
    returns (bool) {
        return MerkleProof.verify(_merkleProof, _merkleRoot, _leaf);
    }

    function createLegalContract(bytes32[] calldata _merkleProof, bytes32 _merkleRoot, bytes32 _subNode, bytes memory _data)
    external {
        require(isWhiteListed(msg.sender, _merkleRoot, _merkleProof));

        address _token = address(uint160(uint256(
            keccak256(abi.encodePacked(
                keccak256(abi.encodePacked(msg.sender)),
                _subNode
            ))
        )));
        registrar = new AirdropRegistrar(_token);
        legalContract = new LegalContractNFT(
            msg.sender, 
            uint256(uint160(_token)), 
            string(abi.encodePacked(_token))
        );

        IAirdropRegistrar(address(registrar))
        .registerLawfirmSubdomain(_merkleProof, _merkleRoot, _subNode, _data);

        IAirdropRegistrar(address(registrar))
        .transferNFTOwnership(address(legalContract), msg.sender);
    }

    // function createLegalContract(bytes32[] calldata _merkleProof, bytes32 _subNode, bytes memory _data) 
    // external 
    // onlyPartner {
    //     bytes32 node = keccak256(abi.encodePacked(lawfirmNode, _subNode));
    //     require(
    //         ens.owner(keccak256(abi.encodePacked(lawfirmNode, _subNode))) == address(0),
    //         "Subdomain already taken"
    //     );
        
    //     ens.setSubnodeOwner(
    //         lawfirmNode, 
    //         _subNode,
    //         ens.owner(node)
    //     );

    //     address _tokenId = address(uint160(uint256(
    //         keccak256(abi.encodePacked(
    //             keccak256(abi.encodePacked(msg.sender)),
    //             _subNode
    //         ))
    //     )));

    //     bytes32 merkleRoot = bytes32(abi.encodePacked("merkleRoot"));
    //     // LegalContractNFT firstContract = new LegalContractNFT{value: 100}(
    //     //     msg.sender,
    //     //     merkleRoot, 
    //     //     uint256(uint160(_tokenId)), 
    //     //     string(abi.encodePacked(_tokenId))
    //     // );

    //     legalMembers[msg.sender].legalContracts[_tokenId] = _subNode;
    //     address registrarAddr = address(
    //         IAirdropRegistrar.createAirdropRegistrar(uint256(uint160(_tokenId)))
    //     );
    //     firstContract = IERC721Ac(_tokenId).createNFT(
    //         msg.sender, 
    //         uint256(uint160(_tokenId)), 
    //         string(abi.encodePacked(_tokenId))
    //     );

    //     registrars[uint256(uint160(_tokenId))] = registrarAddr;

    //     IAirdropRegistrar(registrarAddr).registerLawfirmSubdomain(
    //         _merkleProof,
    //         _subNode,
    //         _data
    //     );
    // }

    // function proposeLumpContract(bytes32[] _merkleProof, bytes32 _subNode, bytes _data)
    // external
    // onlyLegalStaff {
    //     bytes32 node = keccak256(abi.encodePacked(lawfirmNode, _subNode));
    //     require(
    //         ens.owner(keccak256(abi.encodePacked(lawfirmNode, _subNode))) != address(0),
    //         ""
    //     );
    //     address _tokenId = address(uint160(uint256(
    //     keccak256(abi.encodePacked(
    //             keccak256(abi.encodePacked(msg.sender)),
    //             _subNode
    //         ))
    //     )))

    //     AirdropRegistrar(tokenId).attachLumpContract()
    // }

    // function commentLumpContract(bytes32[] _merkleProof, bytes32 _subNode, bytes _data)
    // external
    // only
}
