import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("Marketplace", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployMarketplaceFixture() {
    const BUK_PROTOCOL = "0x72a8d29b9b9EFCc0B58e11bb42686a527f978699";
    const BUK_NFT = "0xd84C3b47770aeCF852E99C5FdE2C987783027385";
    const CURRENCY = "0xae9B20071252B2f6e807D0D58e94763Aa08905aB";
    const WALLET = "0xa9a1C7be37Cb72811A6C4C278cA7C403D6459b78";
    const BUK_ROYALTY = 5;
    const HOTEL_ROYALTY = 2;
    const USER_ROYALTY = 1;

    // Contracts are deployed using the first signer/account by default
    const [owner, otherAccount] = await ethers.getSigners();
    console.log(owner, " owner");

    const Marketplace = await ethers.getContractFactory("Marketplace");
    const marketplaceContract = await Marketplace.deploy(
      BUK_PROTOCOL,
      BUK_NFT,
      WALLET,
      WALLET,
      BUK_ROYALTY,
      HOTEL_ROYALTY,
      USER_ROYALTY,
      CURRENCY,
    );

    return {
      marketplaceContract,
      BUK_PROTOCOL,
      BUK_NFT,
      CURRENCY,
      WALLET,
      BUK_ROYALTY,
      HOTEL_ROYALTY,
      USER_ROYALTY,
      owner,
      otherAccount,
    };
  }

  describe("Deployment marketplace", function () {
    it("Should set the BUK protocol address", async function () {
      const { marketplaceContract, BUK_PROTOCOL } = await loadFixture(
        deployMarketplaceFixture,
      );
      expect(await marketplaceContract.getBukProtocol()).to.equal(BUK_PROTOCOL);
    });

    it("Should set the BUK NFT address", async function () {
      const { marketplaceContract, BUK_NFT, BUK_PROTOCOL } = await loadFixture(
        deployMarketplaceFixture,
      );
      expect(await marketplaceContract.getBukNFT()).to.equal(BUK_NFT);
    });

    it("Should set the treasury wallet", async function () {
      const { marketplaceContract, WALLET } = await loadFixture(
        deployMarketplaceFixture,
      );
      expect(await marketplaceContract.getTreasuryWallet()).to.equal(WALLET);
    });

    it("Should set the hotel wallet", async function () {
      const { marketplaceContract, WALLET } = await loadFixture(
        deployMarketplaceFixture,
      );
      expect(await marketplaceContract.getHotelWallet()).to.equal(WALLET);
    });

    it("Should set the BUK royalty", async function () {
      const { marketplaceContract, BUK_ROYALTY } = await loadFixture(
        deployMarketplaceFixture,
      );
      expect(await marketplaceContract.getBukRoyalty()).to.equal(BUK_ROYALTY);
    });

    it("Should set the hotel royalty", async function () {
      const { marketplaceContract, HOTEL_ROYALTY } = await loadFixture(
        deployMarketplaceFixture,
      );
      expect(await marketplaceContract.getHotelRoyalty()).to.equal(
        HOTEL_ROYALTY,
      );
    });

    it("Should set the User royalty", async function () {
      const { marketplaceContract, USER_ROYALTY } = await loadFixture(
        deployMarketplaceFixture,
      );
      expect(await marketplaceContract.getUserRoyalty()).to.equal(USER_ROYALTY);
    });

    it("Should set the stable token", async function () {
      const { marketplaceContract, CURRENCY } = await loadFixture(
        deployMarketplaceFixture,
      );
      expect(await marketplaceContract.getStableToken()).to.equal(CURRENCY);
    });
  });
});
