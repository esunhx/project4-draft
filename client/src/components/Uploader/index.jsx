import { useState } from 'react';
import { create } from 'ipfs-http-client';
import { NFTStorage } from 'nft.storage';
import Dropzone from 'react-dropzone';
import axios from 'axios';

function Uploader() {
	const [uploaded, setUploaded] = useState(false);
	const [pdfBuffer, setPDFBuffer] = useState(null);

	const ipfs = () => {
		return create({ host: 'localhost', port: '5001', protocol: 'http' });
	}

	const onDrop = async (acceptedFiles) => {
		const pdfFile = acceptedFiles[0];
		const pdfBuffer = await pdfFile.arrayBuffer();
		setPDFBuffer(pdfBuffer);
	};

	const onSubmit = async (event) => {
		event.preventDefault();
		const pdfHash = await ipfs.add(Buffer.from(pdfBuffer))
		.then((result) => console.log(result))
		.catch((error) => console.error(error));

		const response = await axios.post('/api/upload-pdf', { pdfHash });
		setUploaded(true);
	};

	return (
		<div>
		{!uploaded ? (
			<form onSubmit={onSubmit}>
			<Dropzone onDrop={onDrop} accept=".pdf">
				{({ getRootProps, getInputProps }) => (
				<div {...getRootProps()}>
					<input {...getInputProps()} />
					<p>Drag and drop a PDF file here, or click to select file</p>
				</div>
				)}
			</Dropzone>
			<button type="submit">Upload PDF</button>
			</form>
		) : (
			<p>PDF uploaded successfully!</p>
		)}
		</div>
	);
}

export default Uploader;