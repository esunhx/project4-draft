const LawfirmFactory = artifacts.require("LawfirmFactory");
const Lawfirm = artifacts.require("Lawfirm");
const ENSResolver = artifacts.require("ENSResolver");
const Web3 = require('web3');
const contractAbi = require('../../client/src/contracts/Lawfirm.json');
const { keccak256 } = require('web3-utils');
const { expect } = require("chai");
const { MerkleTree } = require("merkletreejs");

contract("LawfirmFactory", (accounts) => {
  const owner = accounts[0];
  const partnerAddr = accounts[1];
  const name = "lawyerlayers";

  let instance;
  let merkleRoot;
  let tree;

  before(async () => {
    instance = await LawfirmFactory.new({ from: owner });
    constLawfrimAddr = 0x78e7b5fF97Ceaa33367D74888b05af4f2C548198
  });

  it("should create a new Lawfirm", async () => {
    // const proof = tree.getProof("0x" + merkleRoot, 0);
    console.log(owner);
    await instance.createLawfirm(owner, name, { from: owner, value: 100 });
    
    const lawfirmInstance = await Lawfirm.at(lawfirmAddr);

    expect(lawfirmInstance).to.be.instanceOf(Lawfirm);
  });
});

// contract('Lawfirm', () => {
//   it('should read newly written values', async() => {
//     const lawfirmInstance = await Lawfirm.deployed();
//     var value = (await lawfirmInstance.read()).toNumber();

//     assert.equal(value, 0, "0 wasn't the initial value");

//     await lawfirmInstance.write(1);
//     value = (await lawfirmInstance.read()).toNumber();
//     assert.equal(value, 1, "1 was not written");

//     await lawfirmInstance.write(2);
//     value = (await lawfirmInstance.read()).toNumber();
//     assert.equal(value, 2, "2 was not written");
//   });
// });

// contract('ENSResolver', () => {
//   it('should read newly written values', async() => {
//     const ensResolverInstance = await ENSResolver.deployed();
//     var value = (await ensResolverInstance.read()).toNumber();

//     assert.equal(value, 0, "0 wasn't the initial value");

//     await ensResolverInstance.write(1);
//     value = (await ensResolverInstance.read()).toNumber();
//     assert.equal(value, 1, "1 was not written");

//     await ensResolverInstance.write(2);
//     value = (await ensResolverInstance.read()).toNumber();
//     assert.equal(value, 2, "2 was not written");
//   });
// });

// contract('Airdrop', () => {
//   it('should read newly written values', async() => {
//     const airdropInstance = await Airdrop.deployed();
//     var value = (await airdropInstance.read()).toNumber();

//     assert.equal(value, 0, "0 wasn't the initial value");

//     await airdropInstance.write(1);
//     value = (await airdropInstance.read()).toNumber();
//     assert.equal(value, 1, "1 was not written");

//     await airdropInstance.write(2);
//     value = (await airdropInstance.read()).toNumber();
//     assert.equal(value, 2, "2 was not written");
//   });
// });

// contract('LegalContractNFT', () => {
//   it('should read newly written values', async() => {
//     const legalContractNFTInstance = await LegalContractNFT.deployed();
//     var value = (await legalContractNFTInstance.read()).toNumber();

//     assert.equal(value, 0, "0 wasn't the initial value");

//     await legalContractNFTInstance.write(1);
//     value = (await legalContractNFTInstance.read()).toNumber();
//     assert.equal(value, 1, "1 was not written");

//     await legalContractNFTInstance.write(2);
//     value = (await legalContractNFTInstance.read()).toNumber();
//     assert.equal(value, 2, "2 was not written");
//   });
// });
