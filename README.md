# 🪨 Rock Paper Scissors - Best of 5 (Ethereum DApp)

This is a simple Web3-powered game of Rock, Paper, Scissors built on the Ethereum blockchain.

Two players join by depositing **0.001 ETH** each. They then play up to **5 rounds**, and the player with the most wins takes the **entire 0.002 ETH pot**.

If a player stops playing or doesn't respond, the other player can **forfeit** the game and automatically win.

## 🚀 Features

- 🕹️ Turn-based Rock, Paper, Scissors logic (best of 5 rounds)
- 💰 Winner takes all (0.002 ETH reward)
- 👛 MetaMask integration
- ⛓️ Smart contract deployed on Ethereum-compatible networks

## ⚙️ How It Works

1. Both players join the game by sending **0.001 ETH** to the smart contract.
2. They take turns selecting Rock, Paper, or Scissors (up to 5 times).
3. The smart contract automatically calculates who wins each round.
4. After 5 rounds, the player with more wins receives the **0.002 ETH prize**.
5. If a player doesn’t play or leaves, the opponent can **forfeit** to claim the win.

## 🧠 Tech Stack

- Solidity (Smart Contract)
- Web3.js
- HTML + JavaScript (Single-page frontend)
- MetaMask (wallet connection)

## 🛠️ Setup Instructions

1. Deploy the smart contract using [Remix](https://remix.ethereum.org) or Hardhat.
2. Copy the contract ABI and address.
3. Open `index.html` and paste the ABI and contract address where indicated.
4. Launch the HTML file in a browser with MetaMask installed.
5. Start playing!

## 📜 License

MIT

---

Made with 💻 by blockchainfun
