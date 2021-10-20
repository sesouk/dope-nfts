const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory("MyDopeNFT")
  const nftContract = await nftContractFactory.deploy()
  await nftContract.deployed()
  console.log("Contract summoned at:", nftContract.address);

  let txn = await nftContract.makeNFT()
  await txn.wait()
  console.log("Minted NFT #1")

  txn = await nftContract.makeNFT()
  await txn.wait()
  console.log("Minted NFT #2");
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