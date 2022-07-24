const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Startt Testing Uniswap FlashSwap", () => {
	const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
	const WETH9 = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";

	let accounts, swapContract, flashloanContract, dai, weth;

	before(async () => {
		// deploy contracts UniswapSingleHop, UniswapFlashloan
		// swap account eth for USDT, so that able to pay the primium
		// Flashloan Usdt from aave

		accounts = await ethers.getSigners();

		const FlashloanContract = await ethers.getContractFactory(
			"FlashloanUniswap"
		);
		flashloanContract = await FlashloanContract.deploy();
		await flashloanContract.deployed();

		const SwapContract = await ethers.getContractFactory("SwapExamples");
		swapContract = await SwapContract.deploy();
		await swapContract.deployed();

		dai = await ethers.getContractAt(
			"contracts/interfaces/IERC20.sol:IERC20",
			DAI
		);
		weth = await ethers.getContractAt("IWETH", WETH9);
	});

	it("Making Swapping Tokens", async () => {
		const amountIn = 10n ** 18n;

		// convert eth to weth froom accounts[0]
		await weth.connect(accounts[0]).deposit({ value: amountIn });
		await weth.connect(accounts[0]).approve(swapContract.address, amountIn);

		await swapContract.swapExactInputSingle(amountIn);

		console.log(
			"Dai balance After swap :: ",
			await dai.balanceOf(accounts[0].address)
		);
	});

	it("Request for Flashloan", async () => {
		console.log(
			"=========== After Swapping Dai balance of Accounts[0] ============="
		);
		console.log(
			"Dai balance After swap :: ",
			await dai.balanceOf(accounts[0].address)
		);
		const bal = await dai.balanceOf(accounts[0].address);
		await dai.connect(accounts[0]).transfer(flashloanContract.address, bal);

		console.log(
			"=========== After Transfering All Dai to Flashloan Address ============="
		);
		console.log(
			"Dai balance After swap :: ",
			await dai.balanceOf(accounts[0].address)
		);
		console.log(
			"Dai balance of Contract :: ",
			await dai.balanceOf(flashloanContract.address)
		);

		const flashloanAmount = 20000n * 10n ** 18n; // 20000 Dai
		const tx = await flashloanContract
			.connect(accounts[0])
			.flashLoan(dai.address, flashloanAmount);

		// for (const log of tx.logs) {
		// 	console.log(log.args.message, log.args.val.toString());
		// }
		//console.log(tx);

		console.log(
			"============ After Flashloan Success and giving primiums, Remain Dai =============="
		);
		console.log(
			`After FlashLoan My Contract DAI Balance :: ${await dai.balanceOf(
				flashloanContract.address
			)}`
		);
	});
});
