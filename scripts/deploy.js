const {ethers} = require('hardhat');

async function main(){
    const [deployer] = await ethers.getSigners();
    console.log("Deploying the contract with accound:", deployer.address);

    //Set the parameters for vesting
    const vestingInterval = 180; //3 minutes in seconds
    const totalIntervals = 10; // 10 intervals
    const totalVestingAmount = "10000"; //1 Billion tokens with 18 decimals
    const tokenAddress = "0x0C140424cB42c8318b1CF65b63BF70aA5ee218C4";
    // const lockInPeriod = 600; //10min in seconds

    const VestingContract = await ethers.getContractFactory("Vesting");
    const vestingContract_ = await VestingContract.deploy(vestingInterval, totalIntervals, totalVestingAmount, tokenAddress);

    console.log("VestingContract deployed to:", vestingContract_.address);
}

main().catch((error) => {
    console.error(error);
    process.exit(1);
});
