import { useState, useEffect, useCallback } from 'react';
import useEth from '../../contexts/EthContext/useEth';
import SmartContractListener from '../SmartContractListener';

const Lawfirm = () => {
    const {
        state: { contract, accounts, web3 }
    } = useEth();
    const [abiFile, setAbiFile] = useState('');
    const [error, setError] = useState();
    const [success, setSuccess] = useState();

    const successHandler = () => {
        setSuccess(null);
    };

    const errorHandler = () => {
        setError(null);
    };
    
    const lawfirm = (
        <></>
    );
};

export default Lawfirm;