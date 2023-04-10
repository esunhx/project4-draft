// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

//@author Ascanio Macchi di Cellere

import "../../node_modules/@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "../../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "./ENSResolver.sol";
import "./Lawfirm.sol";

contract LawfirmFactory is Ownable, ENSResolver {
    constructor() {
    }

    Lawfirm lawfirm;
    uint internal lawfirmsCounter;

    mapping (string => address) public lawfirms;

    event LawfirmDigitallyFounded(address partnerAddr, address lawfirmAddr, string name);

    function createLawfirm(address _partnerAddr, bytes32 _merkleRoot, string memory _name) 
    external
    onlyOwner {
        bytes32 _tmpNode = keccak256(bytes(string.concat(_name, ".test")));
        bool check = resolve(_tmpNode) == address(uint160(uint256(_tmpNode)));
        require(check, "Lawfirm domain not registered with ENS");
        address _lawfirmAddr = address(new Lawfirm{value: 100}(_partnerAddr, _tmpNode, _merkleRoot));
        lawfirms[_name] = _lawfirmAddr;
        lawfirmsCounter++;

        emit LawfirmDigitallyFounded(_partnerAddr, _lawfirmAddr, _name);
    }
}