const LawfirmFactory = artifacts.require("LawfirmFactory");
const Lawfirm = artifacts.require("Lawfirm");
const LegalContractNFT = artifacts.require("LegalContractNFT");
const { keccak256 } = require('web3-utils');
const { expect } = require("chai");
const { MerkleTree } = require("merkletreejs");
const { BN, expectEvent } = require('@openzeppelin/test-helpers');

contract("LawfirmFactory", (accounts) => {
  let lawfirmFactory;
  let lawfirm;

  const merkleTree = new MerkleTree([
    accounts[0],
    accounts[1]
  ]);

  before(async () => {
    lawfirmFactory = await LawfirmFactory.new({ from: accounts[0] });
  });

  describe("createLawfirm", () => {
    it("should create a new Lawfirm contract", async () => {
      const tx = await lawfirmFactory.createLawfirm(accounts[0], "Test Lawfirm", { from: accounts[0] });

      expect(tx.logs[0].event).to.equal("LawfirmDigitallyFounded");

      lawfirm = await Lawfirm.at(tx.logs[0].args.lawfirmAddr);
      const lawfirmOwner = await lawfirm.owner();

      expect(lawfirmOwner).to.equal(accounts[0]);
    });
  });

  describe("transferLawfirmOwnership", () => {
    it("should transfer ownership of the Lawfirm contract", async () => {
      await lawfirmFactory.transferLawfirmOwnership(lawfirm.address, accounts[1], { from: accounts[0] });

      const lawfirmOwner = await lawfirm.owner();

      expect(lawfirmOwner).to.equal(accounts[1]);
    });
  });
});

contract("Lawfirm", (accounts) => {
  let lawfirm;
  let legalContract;
  const foundingPartner = accounts[0];
  const partner = accounts[1];
  const associate = accounts[2];
  const paralegal = accounts[3];

  beforeEach(async () => {
    lawfirm = await Lawfirm.new(foundingPartner, "Example Law Firm");
    await lawfirm.registerLegalStaff(partner, 1);
    await lawfirm.registerLegalStaff(associate, 2);
    await lawfirm.registerLegalStaff(paralegal, 3);
  });

  it("should allow the founding partner to transfer ownership", async () => {
    await lawfirm.transferLawfirmOwnership(accounts[4], { from: foundingPartner });
    const newOwner = await lawfirm.owner();
    expect(newOwner).to.equal(accounts[4]);
  });

  it("should allow a partner to create a legal contract and mint an NFT", async () => {
    const data = web3.utils.asciiToHex("Example legal contract data");
    const subNode = web3.utils.asciiToHex("subdomain.example");
    const merkleProof = [];
    const merkleRoot = "0x1234";
    await lawfirm.createLegalContract(merkleProof, merkleRoot, subNode, data, { from: partner });
    const tokenAddress = await legalContract.token();
    expect(tokenAddress).to.not.be.undefined;
  });
});

contract("AirdropRegistrar", accounts => {
  const owner = accounts[0];
  const claimer = accounts[1];
  const merkleRoot = keccak256(("_merkleRoot"));
  const subNode = keccak256(claimer);

  beforeEach(async function () {
    this.token = await LegalContractNFT.new("My Token", "MTK", { from: owner });
    this.registrar = await AirdropRegistrar.new(this.token.address, { from: owner });
  });

  describe("constructor", () => {
    it("should set the token address and merkle root", async () => {
      const tokenAddress = await this.registrar.token();
      const root = await this.registrar.merkleRoot();

      expect(tokenAddress).to.equal(this.token.address);
      expect(root).to.equal(merkleRoot);
    });
  });

  describe("canClaim", () => {
    beforeEach(async function () {
      this.tree = new MerkleTree([Buffer.from(subNode)], keccak256, { hashLeaves: false });
      this.treeRoot = "0x" + this.tree.getRoot().toString("hex");
    });

    it("should return true if the address has not claimed and the proof is valid", async () => {
      const result = await this.registrar.canClaim(claimer, this.tree.getProof(Buffer.from(subNode)));
      expect(result).to.equal(true);
    });

    it("should return false if the address has already claimed", async () => {
      await this.registrar.resetClaim(claimer);
      await this.registrar.registerLawfirmSubdomain(this.tree.getProof(Buffer.from(subNode)), merkleRoot, subNode, "data", { from: claimer });

      const result = await this.registrar.canClaim(claimer, this.tree.getProof(Buffer.from(subNode)));
      expect(result).to.equal(false);
    });

    it("should return false if the proof is not valid", async () => {
      const fakeSubNode = keccak256(abi.encodePacked("fake"));
      const result = await this.registrar.canClaim(claimer, this.tree.getProof(Buffer.from(fakeSubNode)));
      expect(result).to.equal(false);
    });
  });

  describe("registerLawfirmSubdomain", () => {
    beforeEach(async function () {
      this.tree = new MerkleTree([Buffer.from(subNode)], keccak256, { hashLeaves: false });
      this.treeRoot = "0x" + this.tree.getRoot().toString("hex");
    });

    it("should mint an NFT to the claimer if the claim is valid", async () => {
      const { logs } = await this.registrar.registerLawfirmSubdomain(this.tree.getProof(Buffer.from(subNode)), merkleRoot, subNode, "data", { from: claimer });

      expectEvent.inLogs(logs, "Registered", { subNode });
      const balance = await this.token.balanceOf(claimer);
      expect(balance).to.bignumber.equal(new BN(1));
    });
  });
});