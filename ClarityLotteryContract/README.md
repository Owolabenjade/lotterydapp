# Clarity Lottery Smart Contract

## Overview

The Clarity Lottery Smart Contract is a decentralized application (dApp) built on the Stacks blockchain using the Clarity programming language. This contract allows users to participate in a lottery by sending a predefined amount of STX (Stacks tokens) and automatically selects a winner at the end of the lottery. The winner receives the entire pot of STX collected during the lottery.

## Features

- **Simple Entry Mechanism**: Users can enter the lottery by sending a fixed amount of STX.
- **Automated Winner Selection**: A random winner is selected when the lottery ends.
- **Transparent and Secure**: All transactions and state changes are recorded on the blockchain, ensuring transparency and security.
- **Resettable**: The lottery resets automatically after each round, making it easy to run multiple lotteries.

## Prerequisites

- **Stacks CLI**: Install the Stacks CLI to interact with the Stacks blockchain.
- **Clarity Tools**: Familiarize yourself with Clarity and the associated tools.
- **STX Wallet**: You'll need a STX wallet to interact with the contract on the testnet or mainnet.

## Contract Overview

### Constants

- **`TICKET_COST`**: The price of a single lottery ticket, set to 100 microSTX.

### Data Variables

- **`is-lottery-active`**: A boolean that indicates whether the lottery is currently active.
- **`total-pot`**: An unsigned integer that tracks the total amount of STX collected in the lottery.
- **`lottery-participants`**: A list of up to 200 participants' addresses who have entered the lottery.

### Public Functions

- **`enter-lottery`**: Allows users to enter the lottery by sending the specified `TICKET_COST`. The function checks if the lottery is active and if the correct amount of STX is transferred before adding the user to the participants list and updating the total pot.
- **`end-lottery-and-select-winner`**: Closes the current lottery, selects a random winner from the participants, transfers the total pot to the winner, and resets the lottery for the next round.

### Private Functions

- **`random`**: A helper function to generate a pseudo-random index based on the block height and the number of participants. This function is used to select the winner.

## Installation and Deployment

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/clarity-lottery.git
cd clarity-lottery
```

### 2. Set Up Your Environment

Ensure you have the Stacks CLI installed and configured. You can follow the official [Stacks documentation](https://docs.stacks.co) for setup instructions.

### 3. Deploy the Contract

To deploy the contract on the testnet:

```bash
stx deploy contract clarity-lottery ./clarity-lottery.clar --testnet
```

Make sure to replace the file path with the correct location of your contract file.

### 4. Interact with the Contract

You can interact with the contract using the Stacks CLI or any Stacks wallet that supports smart contract interaction.

#### Example: Enter the Lottery

```bash
stx call --contract clarity-lottery --function enter-lottery --testnet --sender YOUR_ADDRESS --args
```

#### Example: Close the Lottery and Select Winner

```bash
stx call --contract clarity-lottery --function end-lottery-and-select-winner --testnet --sender YOUR_ADDRESS --args
```

## Testing

Testing is crucial to ensure the contract works as expected. You can write unit tests using Clarity's testing framework or manually test by interacting with the deployed contract on the Stacks testnet.

### Sample Test Case

1. Deploy the contract.
2. Simulate multiple users entering the lottery.
3. Execute the `end-lottery-and-select-winner` function and verify the winner receives the total pot.

## Future Improvements

- **Improved Randomness**: Integrate a more robust randomness mechanism, such as Chainlink VRF or a similar service, to ensure fairness in winner selection.
- **Custom Ticket Pricing**: Allow the contract deployer to set the ticket price dynamically.
- **Enhanced Lottery Management**: Add functionalities to pause, resume, or completely stop the lottery by the contract owner.

## Contributing

Contributions are welcome! If you'd like to contribute to the project, please fork the repository and create a pull request with your changes.

### Steps to Contribute

1. Fork the repository.
2. Create a new branch: `git checkout -b feature/your-feature-name`.
3. Commit your changes: `git commit -m 'Add some feature'`.
4. Push to the branch: `git push origin feature/your-feature-name`.
5. Open a pull request.

## Author

Benjamin Owolabi