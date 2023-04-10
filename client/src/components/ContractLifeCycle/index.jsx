import { useState, useEffect } from 'react';
import useEth from '../../contexts/EthContext/useEth';

function ContractLifeCycle() {
	const {
		state: { contract, accounts, web3 }
	} = useEth();
	
	const [legalContract, setLegalContract] = useState(null);
	const [cycle, setCycle] = useState();

	useEffect(() => {
		const myContract = new web3.eth.Contract(
		MyNFTContract.abi,
		
		);
		setContract(myContract);
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

	return <></>;
}

export default ContractLifeCycle;