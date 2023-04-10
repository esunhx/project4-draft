// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

//@author Ascanio Macchi di Cellere

import "../../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../../node_modules/@ensdomains/ens-contracts/contracts/registry/ENSRegistry.sol";
import "../../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "../nftregistry/Airdrop.sol";
import "../nftregistry/LegalContractNFT.sol";

contract Lawfirm is Ownable, ENSRegistry {
    bytes32 public immutable lawfirmNode;
    bytes32 internal immutable merkleRoot;

    ENS internal immutable ens = ENS(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e);
    ENS lawfirmENS;
    AirdropRegistrar registrar;

    mapping (bytes32 => LegalContractNFT) public legalContracts;
    
    constructor(address _foundingPartner, bytes32 _lawfirmNode, bytes32 _merkleRoot) payable {
        legalMembers[_foundingPartner].isActive = true;
        legalMembers[_foundingPartner].isPartner = true;
        lawfirmNode = _lawfirmNode;
        lawfirmENS = ENS(address(uint160(uint256(_lawfirmNode))));
        merkleRoot = _merkleRoot;
    }

    struct LegalStaff {
        bool isActive;
        bool isPartner;
        bool isAssociate;
        bool isParalegal;
        mapping (bytes32 => address) legalContracts;
        mapping (address => uint) clients; 
    }

    mapping (address => LegalStaff) public legalMembers;

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

    function createLegalContract(bytes32[] calldata _merkleProof, bytes32 _subNode, bytes memory _data) 
    external 
    onlyPartner {
        bytes32 node = keccak256(abi.encodePacked(lawfirmNode, _subNode));
        require(
            ens.owner(keccak256(abi.encodePacked(lawfirmNode, _subNode))) == address(0),
            "Subdomain already taken"
        );
        
        ens.setSubnodeOwner(
            lawfirmNode, 
            _subNode,
            ens.owner(node)
        );

        address _tokenId = address(uint160(uint256(
            keccak256(abi.encodePacked(
                keccak256(abi.encodePacked(msg.sender)),
                _subNode
            ))
        )));

        string memory _tokenBaseURI = string(abi.encodePacked(_tokenId));
        LegalContractNFT firstContract = new LegalContractNFT{value: 100}(
            msg.sender,
            merkleRoot, 
            uint256(uint160(_tokenId)), 
            string(abi.encode(_tokenBaseURI))
        );

        legalMembers[msg.sender].legalContracts[_subNode] = _tokenId;
        registrar = new AirdropRegistrar{value: 100}(_tokenId, merkleRoot);

        registrar.registerLawfirmSubdomain(
            _merkleProof,
            _subNode,
            _data
        );
    }

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
