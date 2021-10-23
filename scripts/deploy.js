const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("MyDopeNFT")
  const nftContract = await nftContractFactory.deploy()
  await nftContract.deployed()
  console.log("Contract summoned at:", nftContract.address);
}

const runMain = async () => {
  try {
    await main()
  } catch (error) {
    console.log(error);
    process.exit(1)
  }
}

runMain()