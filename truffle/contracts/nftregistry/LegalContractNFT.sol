// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//@author Ascanio Macchi di Cellere
//@dev NFT contract to generate legal contracts NFTs

import "../../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../../node_modules/@openzeppelin/contracts/access/AccessControl.sol";
import "../../node_modules/@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "../../node_modules/erc721a/contracts/ERC721A.sol";
import "../../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "../../node_modules/@openzeppelin/contracts/utils/Strings.sol";

contract LegalContractNFT is Ownable, ERC721A, AccessControl {
    using Counters for Counters.Counter;
    using Strings for uint;

    bytes32 public merkleRoot;
    string public baseURI;
    string public uri;
    uint8 public constant MAX_ORIGINAL_COPIES = 250;
    
    mapping (address => bool) internal parties;
    mapping (address => address) internal partiesAwareness;

    enum ContractLifeCycle {
        IdentificationOfParties,
        AwarenessOfParties,
        LumpContract,
        LumpProposal,
        LumpResponse,
        LumpApproved,
        ContractFinal,
        ContractSigned
    }

    enum ContractNature {
        AgencyContract,
        SaleContract,
        SupplyContract,
        DistributionContract,
        LeaseContract,
        LicenceContract,
        ManufacturingContract,
        FranchisingContract
    }

    enum RoleOfParties {
        PrincipalAgent,
        BuyerGuarantor,
        SupplierCustomer,
        ProducerDistributor,
        OwnerTenantGuarantor,
        LicensorLicensee,
        ManufacturerDeveloper,
        FranchisorFranchisee
    }

    ContractLifeCycle public currentContractCycle;
    ContractNature public contractNature;
    RoleOfParties public roleOfParties;

    event PartyIdentified(address partyAddr);
    event AwareOf(address partyAddr);
    event LifeCycleEvent(
        ContractLifeCycle oldLifeCycle, 
        ContractLifeCycle newLifeCycle
    );

    uint256 public immutable tokenId;
    Counters.Counter private _tokenIdCounter;
    
    constructor(address _partnerAddr, uint256 _tokenId, string memory _baseURI)
    ERC721A("LegalContractNFT","LCNFT") {
        parties[_partnerAddr] = true;
        merkleRoot = bytes32(abi.encodePacked(("_merkleRoot")));
        tokenId = _tokenId;
        baseURI = _baseURI;
    }

    modifier verifyLifeCycle(ContractLifeCycle _cycle) {
        require(currentContractCycle == _cycle, "Action outside event scope");
        _;
    }

    modifier lifeCycleIncrement() {
        _;
        nextContractCycle();
    }

    function safemint(address _addr, uint8 _quantity, bytes32[] calldata _merkleProof, bytes memory _data) 
    external {
        require(isWhiteListed(_addr, _merkleProof), "Not WhiteListed");
        require(_quantity < 2, "Maximum mint quantity exceeded");
        _safeMint(_addr, _quantity, _data);
    }

    // function createNFT(address _partnerAddr, uint256 _tokenId, string memory _tokenBaseURI) 
    // external 
    // returns (LegalContractNFT _newNFT) {
    //     return (new LegalContractNFT(_partnerAddr, _tokenId, _tokenBaseURI));
    // }

    function supportsInterface(bytes4 interfaceId) 
    public 
    view 
    override(ERC721A, AccessControl)
    returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function nextContractCycle() internal {
        currentContractCycle = ContractLifeCycle(uint(currentContractCycle)+1);
    }

    function setMerkleRoot(bytes32 _merkleRoot) 
    external 
    onlyOwner {
        merkleRoot = _merkleRoot;
    }

    function setBaseURI(string memory _baseURI)
    external
    onlyOwner {
        baseURI = _baseURI;
    }

    function isWhiteListed(address partyAddr, bytes32[] calldata _merkleProof) 
    internal 
    view 
    returns (bool) {
        return _verify(leaf(partyAddr), _merkleProof);
    }

    function leaf(address partyAddr) 
    internal
    pure 
    returns (bytes32){
        return (keccak256(abi.encodePacked(partyAddr)));
    }

    function _verify(bytes32 _leaf, bytes32[] memory _merkleProof) 
    internal 
    view 
    returns (bool) {
        return MerkleProof.verify(_merkleProof, merkleRoot, _leaf);
    }

    function setTokenURI(uint256 _tokenId)
    external {
        require(
            !_exists(_tokenId), 
            "URI query for existing token"
        );

        uri = string(
            abi.encodePacked(
                baseURI, 
                _tokenId.toString(), 
                ".json"
            )
        );
    }

    function tokenURI(uint256 _tokenId)
    public
    view
    virtual
    override
    returns (string memory) {
        require(
            _exists(_tokenId), 
            "URI query for non-existing token"
        );

        return uri;
    }

    function burn(uint256 _tokenId) 
    external
    onlyOwner {
        _burn(_tokenId);
    }

    function assignRoleOfParties(uint32 _roleNumber) 
    external 
    onlyOwner {
        require(
            roleOfParties != RoleOfParties(_roleNumber), 
            "Role of parties has already been assigned"
        );
        roleOfParties = RoleOfParties(_roleNumber);
    }

    // function 
    
    function beginPartiesIdentification(address partyAddr)
    external
    onlyOwner 
    verifyLifeCycle(
        ContractLifeCycle.IdentificationOfParties
    ) {
        parties[partyAddr] = true;
        emit PartyIdentified(partyAddr);
    }

    function beginPartiesAwareness() 
    external
    onlyOwner
    verifyLifeCycle(ContractLifeCycle.IdentificationOfParties) 
    lifeCycleIncrement {
        emit LifeCycleEvent(
            ContractLifeCycle.IdentificationOfParties,
            ContractLifeCycle.AwarenessOfParties
        );
    }

    function partyAwareness(address partyAddr) 
    external 
        {
        require(parties[partyAddr], "Party not identified");
        partiesAwareness[msg.sender] = partyAddr;
        emit AwareOf(partyAddr);
    }

    function beginLumpContract()
    external
    onlyOwner
    verifyLifeCycle(ContractLifeCycle.AwarenessOfParties)
    lifeCycleIncrement {

    }

    function beginLumpResponse()
    external
    onlyOwner
    verifyLifeCycle(ContractLifeCycle.LumpContract) 
    lifeCycleIncrement {

    }

    function beginLumpApproved()
    external
    onlyOwner
    verifyLifeCycle(ContractLifeCycle.LumpResponse)
    lifeCycleIncrement {

    }

    function finaliseContract()
    external
    onlyOwner
    verifyLifeCycle(ContractLifeCycle.LumpApproved)
    lifeCycleIncrement {

    }

    function signContract()
    external
    onlyOwner
    verifyLifeCycle(ContractLifeCycle.ContractFinal)
    lifeCycleIncrement {
        
    }

    // function requestOriginalCopy()
}