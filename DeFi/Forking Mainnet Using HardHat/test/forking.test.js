const { expect } = require("chai");
const { ethers, network } = require("hardhat");

const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
const USDC = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
const USDT = "0xdAC17F958D2ee523a2206206994597C13D831ec7";

//WHALE must be an account, not contract
const DAI_WHALE = "0x2FAF487A4414Fe77e2327F0bf4AE2a264a776AD2";
const USDC_WHALE = "0x55fe002aeff02f77364de339a1292923a15844b8";
const USDT_WHALE = "0x5754284f345afc66a98fbb0a0afe71e0f007b949";

describe("Test unlock accounts", () => {
	let accounts;
	let dai, usdc, usdt;
	let whale1, whale2, whale3;

	before(async () => {
		await network.provider.request({
			method: "hardhat_impersonateAccount",
			params: [USDC_WHALE],
		});

		//whale1 = await ethers.getSigner(DAI_WHALE);
		whale2 = await ethers.getSigner(USDC_WHALE);
		//whale3 = await ethers.getSigner(USDT_WHALE);

		//dai = await ethers.getContractAt("IERC20", DAI);
		usdc = await ethers.getContractAt("IERC20", USDC);
		//usdt = await ethers.getContractAt("IERC20", USDT);

		accounts = await ethers.getSigners();
	});

	it("unlock account", async () => {
		const amount1 = 100n * 10n ** 18n; // DAI = 18 decimal
		const amount2 = 100n * 10n ** 6n; // USDC & USDT = 6 decimal

		//console.log("DAI balance of whale", await dai.balanceOf(DAI_WHALE));
		console.log("USDC balance of whale", await usdc.balanceOf(USDC_WHALE));
		//console.log("USDT balance of whale", await usdt.balanceOf(USDT_WHALE));

		//expect(await dai.balanceOf(DAI_WHALE)).to.gte(amount1);
		expect(await usdc.balanceOf(USDC_WHALE)).to.gte(amount2);
		//expect(await usdt.balanceOf(USDT_WHALE)).to.gte(amount2);

		//await dai.connect(whale1).transfer(accounts[0].address, amount1);
		await usdc.connect(whale2).transfer(accounts[0].address, amount2);
		//await usdt.connect(whale3).transfer(accounts[0].address, amount2);

		// console.log(
		// 	"DAI balance of account",
		// 	await dai.balanceOf(accounts[0].address)
		// );
		console.log(
			"USDC balance of account",
			await usdc.balanceOf(accounts[0].address)
		);
		// console.log(
		// 	"USDT balance of account",
		// 	await usdt.balanceOf(accounts[0].address)
		// );
	});
});
