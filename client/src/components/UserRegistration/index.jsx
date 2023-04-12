import { useState, useEffect } from "react";
import useEth from '../../contexts/EthContext/useEth';

const UserRegistration = () => {
    const {
        state: { contract, accounts, web3 }
    } = useEth();

    const userRegistration = ( <>
    </>)

    return <div>{userRegistration}</div>
}

export default UserRegistration;