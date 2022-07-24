const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Start Testing UniswapV2Swapping", () => {
	const USDC = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
	const WETH = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";

	let accounts, swappingContract, usdc, weth;

	before(async () => {
		accounts = await ethers.getSigners();

		const SwappingContract = await ethers.getContractFactory("SwappingToken");
		swappingContract = await SwappingContract.deploy();
		await swappingContract.deployed();

		usdc = await ethers.getContractAt(
			"contracts/interfaces/IERC20.sol:IERC20",
			USDC
		);
		weth = await ethers.getContractAt("IWETH", WETH);
	});

	it("Should Swap WETH for USDC", async () => {
		const amountIn = 10n ** 18n; // 1 ETH
		const amountOut = 1000n * 10n ** 6n; // 1000 USDC

		await weth.connect(accounts[0]).deposit({ value: amountIn });
		await weth.connect(accounts[0]).approve(swappingContract.address, amountIn);

		console.log("============= Before Swapping ================");
		console.log(
			"WETH Balance of Account-0 :: ",
			await weth.balanceOf(accounts[0].address)
		);
		console.log(
			"USDC Balance of Account-0 :: ",
			await usdc.balanceOf(accounts[0].address)
		);

		const tx = await swappingContract
			.connect(accounts[0])
			.Swapping(
				weth.address,
				usdc.address,
				amountIn,
				amountOut,
				accounts[0].address
			);

		console.log("============= After Swapping ================");
		console.log(
			"WETH Balance of Account-0 :: ",
			await weth.balanceOf(accounts[0].address)
		);
		console.log(
			"USDC Balance of Account-0 :: ",
			await usdc.balanceOf(accounts[0].address)
		);
	});
});
