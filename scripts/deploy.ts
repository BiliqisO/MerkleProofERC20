import { ethers } from "hardhat";

async function main() {
  const root =
    "96af0c2fae069f9b01f02310bdd93634ed27b162d0ae24db1587a6258e1d01f2";

  const merkleToken = await ethers.deployContract("MerkleToken", [root]);

  await merkleToken.waitForDeployment();

  console.log(` deployed to ${merkleToken.target}`);
}
async function main2() {
  const merkleTokenAddr = "";
  const interactWMContract = await ethers.getContractAt(
    "MerkleToken",
    merkleTokenAddr
  );
  const impersonatedSigner = await ethers.getImpersonatedSigner(
    "0x001Daa61Eaa241A8D89607194FC3b1184dcB9B4C"
  );

  async function distributeToAddr1() {
    await interactWMContract.transfer(
      impersonatedSigner,
      ethers.parseEther("10"),
      [
        "0xc38db87582dda0be501d2042fb49e20f7a9fc98397ae63a6b46ea3e20ee61616",
        "0x7423d6d83607b81ac8afcc31122377e2bc6acf0bed2da4e33e06fad8f625020b",
        "0x47d79263b3efee4f4d9470121dcd87e2c20dbe7025531b813367b8ca7f3cc30a",
      ]
    );
    console.log(await interactWMContract.balanceOf(impersonatedSigner));
  }
  distributeToAddr1();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
