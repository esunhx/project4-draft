// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

abstract contract ENSabs {
    function resolver(bytes32 node) 
    public 
    virtual 
    view 
    returns (Resolver);
}

abstract contract Resolver {
    function addr(bytes32 node) 
    public 
    virtual 
    view 
    returns (address);
}

contract ENSResolver {
    ENSabs internal immutable ens = ENSabs(0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e);

    constructor() {}

    function resolve(bytes32 node) 
    public 
    view 
    returns(address) {
        Resolver resolver = ens.resolver(node);
        return resolver.addr(node);
    }
}
