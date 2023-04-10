import { useState, useEffect, useCallback } from 'react';
import useEth from '../../contexts/EthContext/useEth';
import ErrorModal from '../../components/utils/ErrorModal';
import SuccessModal from '../../components/utils/SuccessModal';
import Button from '../../components/utils/Button';

const Home = () => {
    const {
        state: { contract, accounts }
    } = useEth();
    const [lawfirm, setLawfirm] = useState('');
    const [registered, setRegistered] = useState(false);
    const [error, setError] = useState();
    const [success, setSuccess] = useState();

    const addFounderHandler = async () => {
        await contract.methods.createLawfirm(accounts[0], lawfirm).send({ from: accounts[0] });
        setSuccess(`${lawfirm} has been successfully added`);
        setLawfirm();
    };

    const lawfirmHandler = (event) => {
        setLawfirm(event.target.value);
    };

    const onRegistration = async (event) => {
        setRegistered(true);
    }

    const registrationHandler = () => {
        setRegistered(false);
    }

    const errorHandler = () => {
        setError(null);
    };
    
    const successHandler = () => {
        setSuccess(null);
    };

    const home = (
        <>
            {error && <ErrorModal title={error.title} message={error.message} onClick={errorHandler} />}
            {success && <SuccessModal message={success} onClick={successHandler} />}
            <div className="wd-full">
                <div className="justify-center text-center">
                    <div className="space-x-4">
                        <input
                        className="rounded-md h-8 p-2 my-2 border border-sky-800"
                        value={lawfirm}
                        onInput={lawfirmHandler}
                        />
                        <Button label="Create Lawfirm" onClick={addFounderHandler} />
                    </div>
                </div>
            </div>
        </>
    )
    
    return <div className="align bg-background bg-cover min-h-screen">{home}</div>;
};

export default Home;