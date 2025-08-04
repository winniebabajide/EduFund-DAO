# EduFund DAO

A blockchain-powered scholarship and education funding platform that enables global communities to transparently fund, govern, and track educational journeys for students in underserved regions — all on-chain.

---

## Overview

EduFund DAO consists of ten smart contracts that form a decentralized, impact-driven ecosystem for donors, students, and education advocates:

1. **DAO Governance Contract** – Powers proposal creation, voting, and execution for scholarship decisions.
2. **Treasury Management Contract** – Securely holds and routes all community-donated funds.
3. **Student Application Contract** – Handles student submissions, verification, and updates.
4. **Scholarship Escrow Contract** – Holds and releases funds in tranches based on milestones.
5. **Milestone Verification Contract** – Tracks student progress via verified submissions.
6. **Reputation & Audit Contract** – Maintains reputation scores for students, donors, and verifiers.
7. **Donor Staking & Rewards Contract** – Incentivizes donor participation via staking and token rewards.
8. **Credential NFT Contract** – Issues on-chain, verifiable NFT diplomas and achievements.
9. **Referral & Bounty Contract** – Rewards users for onboarding students or verifying data.
10. **Emergency Multi-Sig Contract** – Allows DAO members to pause or re-route funds in edge cases.

---

## Features

- **Community-funded scholarships** governed by token-weighted voting  
- **Milestone-based disbursement** for verified student progress  
- **Transparent treasury management** with real-time visibility  
- **On-chain student applications** with DID or community review  
- **NFT credentials** for academic achievements and completion  
- **Reputation tracking** for verifiers, students, and donors  
- **Staking rewards** for active participants and funders  
- **Bounty system** to incentivize growth and verification  
- **Multi-sig emergency handling** to protect funds from abuse  
- **Open, auditable education funding system** without middlemen  

---

## Smart Contracts

### DAO Governance Contract
- Submit, vote on, and execute proposals
- Token-weighted voting with quorum
- Time-based voting windows and thresholds

### Treasury Management Contract
- Receive and hold funds
- Route funds to escrow or milestone contracts
- Transaction transparency with logs

### Student Application Contract
- Submit personal, academic, and need-based data
- DID or community-powered identity verification
- Status tracking per applicant

### Scholarship Escrow Contract
- Lock funds per student
- Release funds upon milestone verification
- Reclaim unspent funds if goals not met

### Milestone Verification Contract
- Accepts proof (certificates, enrollment, transcripts)
- Uses oracles or community verifiers for validation
- Updates student status on-chain

### Reputation & Audit Contract
- Tracks student performance and credibility
- Rewards community auditors for accurate checks
- Maintains DAO-wide trust layer

### Donor Staking & Rewards Contract
- Stake tokens to support scholarship pools
- Earn reward tokens or governance boosts
- Optional vesting mechanics

### Credential NFT Contract
- Issue NFTs for graduation, certifications, achievements
- Soulbound (non-transferable) or collectible formats
- On-chain proof of education history

### Referral & Bounty Contract
- Onboard new students or schools
- Verify applications and documents
- Earn tokenized rewards or badges

### Emergency Multi-Sig Contract
- DAO-elected signers for emergencies
- Pause funding or revoke misused contracts
- Restore control to DAO after resolution

---

## Installation

1. Install [Clarinet CLI](https://docs.hiro.so/clarinet/getting-started)
2. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/edufund-dao.git
   ```
3. Run tests:
    ```bash
    npm test
    ```
4. Deploy contracts:
    ```bash
    clarinet deploy
    ```

## Usage

Each smart contract is modular and can operate independently or as part of the full EduFund DAO ecosystem.
Refer to the contracts/ directory for detailed documentation on each contract's interface, expected inputs, and security assumptions.

## License

MIT License