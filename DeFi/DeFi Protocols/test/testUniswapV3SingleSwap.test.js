const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Start Testing UniswapV3SingleHop", () => {
	const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
	const WETH9 = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
	const USDC = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";

	let accounts, weth, dai, singleHop;

	before(async () => {
		// get accounts
		accounts = await ethers.getSigners();

		// initialize weth and dai
		weth = await ethers.getContractAt("IWETH", WETH9);
		dai = await ethers.getContractAt(
			"contracts/interfaces/IERC20.sol:IERC20",
			DAI
		);

		// deploy contract
		const SingleHop = await ethers.getContractFactory("SwapExamples");
		singleHop = await SingleHop.deploy();
		await singleHop.deployed();
	});

	it("Start Testing SingleHop", async () => {
		const amountIn = 10n ** 18n; // js supports big int

		// convert eth to weth froom accounts[0]
		await weth.connect(accounts[0]).deposit({ value: amountIn });
		await weth.connect(accounts[0]).approve(singleHop.address, amountIn);

		await singleHop.swapExactInputSingle(amountIn);

		console.log(
			"Dai balance After swap :: ",
			await dai.balanceOf(accounts[0].address)
		);
	});

	it("Start Testing Fixed amount out using minInput", async () => {
		const wethAmountInMax = 10n ** 18n; // js supports big int
		const daiAmountOut = 100n * 10n ** 18n;

		// convert eth to weth froom accounts[0]
		await weth.connect(accounts[0]).deposit({ value: wethAmountInMax });
		await weth.connect(accounts[0]).approve(singleHop.address, wethAmountInMax);

		await singleHop.swapExactOutputSingle(daiAmountOut, wethAmountInMax);

		console.log(
			"Dai balance After swap :: ",
			await dai.balanceOf(accounts[0].address)
		);
	});
});
