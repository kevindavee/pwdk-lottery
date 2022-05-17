import { expect } from "chai";
import { ethers } from "hardhat";

describe("Lottery", function () {
  it("should increase balance after fund has been deposit", async () => {
    const factory = await ethers.getContractFactory("Lottery");
    const lottery = await factory.deploy();
    await lottery.deployed();

    const [, alice] = await ethers.getSigners();
    await lottery.connect(alice).depositFund({
      value: ethers.utils.parseEther("0.5"),
    });

    const aliceBalance = await lottery.playersBalance(alice.address);
    expect(aliceBalance.toString()).to.be.equal(
      ethers.utils.parseEther("0.5").toString()
    );
  });

  it("should not register Alice address twice in playersAddress", async () => {
    const factory = await ethers.getContractFactory("Lottery");
    const lottery = await factory.deploy();
    await lottery.deployed();

    const [, alice] = await ethers.getSigners();
    await lottery.connect(alice).depositFund({
      value: ethers.utils.parseEther("0.5"),
    });
    await lottery.connect(alice).depositFund({
      value: ethers.utils.parseEther("0.3"),
    });

    const result = await lottery.playersAddress(1);
    expect(result).not.to.be.eq(alice.address);
  });
});
