import { useState, useEffect } from 'react';
import useEth from '../../contexts/EthContext/useEth';
import SmartContractListener from '../SmartContractListener';

function ContractLifeCycle() {
	const {
		state: { contract, accounts, web3 }
	} = useEth();
	const [abiFile, setAbiFile] = useState('');
	const [legalContract, setLegalContract] = useState(null);
	const [cycle, setCycle] = useState();

	useEffect(() => {
        async function fetchAbi() {
                const abiModule = await import('../../contracts/LegalContractNFT.json');
                setAbiFile(abiModule.default);
            }; fetchAbi();
    },  []);

	useEffect(() => {
		const legalContract = new web3.eth.Contract(
		abiFile,
		
		);
		setContract(legalContract);
	}, []);

	const cycleToString = (cycle) => {
		const cycles = {
		0: "IdentificationOfParties",
		1: "AwarenessOfParties",
		2: "LumpContract",
		3: "LumpProposal",
		4: "LumpResponse",
		5: "LumpApproved",
		6: "ContractFinal",
		7: "ContractSigned"
		}
		return cycles(cycle);
	}
	
	useEffect(() => {}, [contract])

	contractLifeCycle = (
		<>
		</>
	)
	// return <div className='justify-center'>{contractLifeCycle}<div/>
}

export default ContractLifeCycle;