const hre = require("hardhat");

async function main() {
  // We get the contract to deploy
  const Zero = await hre.ethers.getContractFactory("Zero");
  const zero = await Zero.deploy();
  await zero.deployed();
  console.log("Zero deployed to:", zero.address);

  let txn = await zero.mint();
  await txn.wait();
  console.log("Minted NFT#1");

  txn = await zero.mint();
  await txn.wait();
  console.log("Minted NFT#2");

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});
