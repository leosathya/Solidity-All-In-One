require("@nomicfoundation/hardhat-toolbox");
const dotenv = require("dotenv");
dotenv.config();
//console.log(process.env.ALCHEMY_API_KEY);

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	solidity: "0.7.6",
	networks: {
		hardhat: {
			forking: {
				url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
			},
		},
	},
};
