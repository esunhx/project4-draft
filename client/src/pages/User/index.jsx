import { useState, useEffect } from 'react';
import useEth from '../../contexts/EthContext/useEth';
import ErrorModal from '../../components/utils/ErrorModal';
import SuccessModal from '../../components/utils/SuccessModal';
import Uploader from '../../components/Uploader';

const User = () => {
    const {
        state: { contract, accounts }
    } = useEth();
    const [currentUser, setCurrentUser] = useState();
    const [partner, setPartner] = useState(false);
    const [associate, setAssociate] = useState(false);
    const [paralegal, setParalegal] = useState(false);
    const [registered, setRegistered] = useState(false);
    const [uploader, setUploader] = useState(true);
    const [error, setError] = useState();
    const [success, setSuccess] = useState();

    // const addUser = async (user) => {
    //     if (!partner) {
    //         setError("You are not authorised");
    //     } else {

    //     }
    // }

    const onRegistration = () => {
        setRegistered(true);
    };
    
    const registrationHandler = () => {
        setRegistered(false);
    };

    const uploaderHandler = () => {
        setUploader(null);
    };

    const successHandler = () => {
        setSuccess(null);
    };

    const errorHandler = () => {
        setError(null);
    };

    const user = (
        <>
            {error && <ErrorModal title={error.title} message={error.message} onClick={errorHandler} />}
            {success && <SuccessModal message={success} onClick={successHandler} />}
            <div class="flex justify-center items-center h-screen bg-gray-100">
                <div class="bg-white p-6 rounded-lg shadow-lg">
                    <div class="text-xl font-semibold mb-4">This is the User Page</div>
                    {uploader && <Uploader/>}
                </div>
            </div>
        </>
        
    )

    return <div className="">{user}</div>;
};

export default User;