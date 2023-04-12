// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//@author Ascanio Macchi di Cellere

import "../../node_modules/@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "../../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "./Lawfirm.sol";
import "./ILawfirm.sol";

contract LawfirmFactory is Ownable {
    constructor() {
    }

    uint public lawfirmsCounter;

    event LawfirmDigitallyFounded(address partnerAddr, address lawfirmAddr, string lawfirmName);

    function createLawfirm(address _partnerAddr, string memory _name) 
    external {
        address _lawfirmAddr = address(new Lawfirm(_partnerAddr, _name));
        lawfirmsCounter++;

        transferLawfirmOwnership(_lawfirmAddr, _partnerAddr);
        emit LawfirmDigitallyFounded(_partnerAddr, _lawfirmAddr, _name);
    }

    function transferLawfirmOwnership(address _lawfirmAddr, address _newOwner) 
    public 
    onlyOwner {
        ILawfirm(_lawfirmAddr).transferLawfirmOwnership(_newOwner);
    }
}