const auction = artifacts.require("./MultiAuction.sol");

module.exports = function (deployer) {
    deployer.deploy(auction)
}