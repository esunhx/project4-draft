import { useState, useEffect } from "react";
import useEth from '../../contexts/EthContext/useEth';

const SmartContractListener = ({ eventName }) => {
    const {
        state: { contract, accounts, web3 }
    } = useEth();

    const [isLawfirm, setIsLawfirm] = useState(false);
    const [isNft, setIsNft] = useState(false);
    const [isAirdrop, setIsAirdrop] = useState(false);
    const [abiFile, setAbiFile] = useState('');
    const [registeredUserEvent, setRegisteredUserEvent] = useState();
    const [contractEvents, setContractEvents] = useState([]);
    const [lawfirmsAddress, setLawfirmsAddress] = useState([]);

    useEffect(() => {
        if (
            eventName=="LegalStaffRegistered" || 
            eventName=="PartnerMintedLegalContract"
        ) {
            setIsLawfirm(true);
            setIsNft(false);
            setIsAirdrop(false);
        } else if (
            eventName=="PartyIdentified" ||
            eventName=="AwareOf" ||
            eventName=="LifeCycleEvent"
        ) {
            setIsNft(true);
            setIsLawfirm(false);
            setIsAirdrop(false);
        } else if (
            eventName="Registered" ||
            eventName=="OriginalCopyIssued"
        ) {
            setIsAirdrop(true);
            setIsNft(false);
            setIsLawfirm(false);
        } else {
            setIsAirdrop(false);
            setIsNft(false);
            setIsLawfirm(false);
        }
    }, [eventName])

    useEffect(() => {
        async function fetchAbi() {
                const abiModule = isLawfirm ? 
                    await import('../../contracts/Lawfirm.json') : 
                    (
                        isNft ?
                        await import('../../contracts/LegalContractNFT.json') :
                        (
                            isAirdrop ?
                            await import('../../contracts/AirdropRegistrar.json') :
                            setAbiFile('')
                        )
                    )
                setAbiFile(abiModule.default);
            }; fetchAbi();
    },  [isLawfirm, isNft, isAirdrop]);

    useEffect(() => {
        if (contract) {
            const eventListener = contract.LawfirmDigitallyFounded({}, (err, ev) => {
                if (err) console.log(err);
                else setContractEvents((prevEvs) => [...prevEvs, ev])
            })
            return () => {eventListener.unsubscribe()};
        }
        setLawfirmsAddress(
            contractEvents.map((event) => event.returnValues.lawfirmAddress)
        );
        contractEventsHandler();
    }, [isLawfirm, isNft, isAirdrop])

    const getContractEvents = async (eventName) => {
        if (contract) {
            const contractEvents = await contract.getPastEvents(`${eventName}`, {
            fromBlock: 0,
            toBlock: "latest",
            }); setContractEvents(contractEvents);
        }
    };
    

    useEffect(() => {}, [eventName])



    // useEffect(() => {
    //     const smartContract = new web3.eth.Contract(
    //         abiFile,
    //         lawfirmAddress
    //     );
    // }, [])
    //     if (callEvent == 0) {
    //         eventListener = smartContract.events.MyEvent({}, (error, event) => {
    //             if (error) console.error(error);
    //             else {
    //                 setMyEvents((prevEvents) => [...prevEvents, event]);
    //             }
    //         });
    //     } else if (callEvent == 1) {
    //         eventListener = smartContract.events.MyEvent({}, (error, event) => {
    //             if (error) console.error(error);
    //             else {
    //                 setMyEvents((prevEvents) => [...prevEvents, event]);
    //             }
    //         });
    //     } else {
    //         setCallEvent(null);
    //     }
    // });
    //     return () => {
    //         eventListener.unsubscribe();
    //     }
    // }, [lawfirmAddress])
    const contractEventsHandler = () => {
        setContractEvents([]);
    } 

    const lawfirmAddressHandler = () => {
        setLawfirmAddress([]);
    }

    const smartContractListener = (
        <>
        </>
    )
    return <div>{smartContractListener}</div>;
};

export default SmartContractListener;
