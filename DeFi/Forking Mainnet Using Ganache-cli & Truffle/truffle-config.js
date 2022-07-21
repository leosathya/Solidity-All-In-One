module.exports = {
	networks: {
		forking__mainnet: {
			host: "127.0.0.1",
			port: 8545, // Standard etherum port
			network_id: "1", //any netwok
		},
	},

	mocha: {
		// timeout: 100000
	},

	// Configure your compilers
	compilers: {
		solc: {
			version: "0.8.11",
		},
	},
};
