// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

//@author Ascanio Macchi di Cellere

import "./Lawfirm.sol";

interface ILawfirm {
    function transferLawfirmOwnership(address newOwner) external;
}