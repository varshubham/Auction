const auction = artifacts.require("./Auction.sol");

module.exports = function (deployer) {
    deployer.deploy(auction)
}