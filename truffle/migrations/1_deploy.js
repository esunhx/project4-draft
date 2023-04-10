const LawfirmFactory = artifacts.require("LawfirmFactory");

module.exports = function (deployer) {
  deployer.deploy(LawfirmFactory)
};
