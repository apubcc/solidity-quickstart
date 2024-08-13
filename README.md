# Devmatch Hackathon Quickstart Repository

Welcome to the official smart contract quickstart repository for the [Devmatch Hackathon](https://devmatch.apubcc.org)! This guide is designed to help you rapidly set up your smart contract development environment using Foundry, so you can focus on building, testing, and deploying your smart contracts during the hackathon.

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```

## Foundry.toml Configuration Breakdown

### `[profile.default]`:

- **`src = "src"`**: Specifies the directory where the source code (Solidity contracts) is located.
- **`out = "out"`**: Specifies the directory where the compiled contract artifacts (e.g., ABI and bytecode) will be stored.
- **`libs = ["lib"]`**: Defines the directory where external libraries (e.g., OpenZeppelin contracts) are stored.
- **`solc = "0.8.23"`**: Sets the Solidity compiler version to `0.8.23`. This ensures that all contracts are compiled with the same, specific version of the Solidity compiler.
- **`solc-optimizer = true`**: Enables the Solidity compiler optimizer. This can help reduce gas costs by optimizing the compiled bytecode.
- **`solc-optimizer-runs = 200`**: Sets the number of optimization runs. `200` is a common setting for a good balance between bytecode size and gas efficiency.
- **`viaIR = true`**: Enables the use of the intermediate representation (IR) pipeline in Solidity. This can provide better optimization results.

### Remappings:

- **`@openzeppelin/=lib/openzeppelin-contracts/`**: Maps imports that start with `@openzeppelin/` to the local directory `lib/openzeppelin-contracts/`. This allows the use of OpenZeppelin libraries easily.
- **`ds-test/=lib/forge-std/lib/ds-test/src/`**: Maps `ds-test/` to the directory where the DSTest library is located. DSTest is a testing framework included with Foundry.
- **`forge-std/=lib/forge-std/src/`**: Maps `forge-std/` to the directory where the Forge Standard Library is located. This provides additional utilities for testing and scripting in Foundry.

### `[etherscan]`:

- **Etherscan Configuration**: These entries provide API keys and URLs for contract verification on blockchain explorers:
  - **`534351`**: Custom Etherscan API entry for the Scroll Sepolia blockchain.
  - **`17000`**: Custom Etherscan API entry for the Ethereum Holesky blockchain.
  - **`11155111`**: Custom Etherscan API entry for the Ethereum Sepolia blockchain.

These API keys are used to automatically verify your contracts on the specified blockchain explorer after deployment, making it easier to interact with and audit your deployed contracts.

## Using the .env.template file

This project includes a `.env.template` file that is crucial for managing environment variables required for deploying and interacting with your smart contracts. Below is an explanation of the variables defined in this file and how to use it:

### Instructions:

1. **Copy the Template**: Start by making a copy of the `.env.template` file and rename it to `.env`.

   ```shell
   cp .env.template .env
   ```

2. **Set your keys**: The `PRIV_KEY` is the private key for the Ethereum account you will use to deploy your contracts. Never share this key publicly and ensure this file is added to your `.gitignore` to avoid committing it to version control.

3. **Configure RPC URLs**: You need to set the RPC URLs for the Ethereum networks you plan to deploy to. For example, this template includes URLs for Scroll and Sepolia testnets.

   ```
   SCROLL_RPC_URL="https://sepolia-rpc.scroll.io/"
   SEPOLIA_RPC_URL="https://eth-sepolia.g.alchemy.com/v2/{YOUR_API_KEY}"
   ```

   Replace {YOUR_API_KEY} in `SEPOLIA_RPC_URL` with your actual API key that you can get from Alchemy or Infura or any other RPC provider.

4. **Set Etherscan API Keys**: These keys are used to verify your smart contracts on the respective blockchains. This template includes placeholders for Etherscan and ScrollScan API keys.
