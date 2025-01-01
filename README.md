# DAO Governance Smart Contract

A comprehensive Decentralized Autonomous Organization (DAO) governance system implemented in Clarity for the Stacks blockchain.

## Features

- 👥 **Membership Management**

  - Join/leave DAO functionality
  - Member reputation tracking
  - Activity-based reputation decay

- 💰 **Treasury Management**

  - Token staking/unstaking
  - Donation handling
  - Balance tracking

- 🗳️ **Proposal System**

  - Create and vote on proposals
  - Quadratic voting (reputation + stake weighted)
  - Automatic proposal expiration
  - Proposal execution logic

- 🤝 **Cross-DAO Collaboration**
  - Propose collaborations with other DAOs
  - Accept/reject collaboration requests
  - Track collaboration status

## Contract Interface

### Membership Functions

```clarity
(define-public (join-dao) ...)
(define-public (leave-dao) ...)
(define-read-only (get-member (user principal)) ...)
(define-read-only (get-total-members) ...)
```

### Staking Functions

```clarity
(define-public (stake-tokens (amount uint)) ...)
(define-public (unstake-tokens (amount uint)) ...)
```

### Proposal Functions

```clarity
(define-public (create-proposal (title (string-ascii 50))
                              (description (string-utf8 500))
                              (amount uint)) ...)
(define-public (vote-on-proposal (proposal-id uint) (vote bool)) ...)
(define-public (execute-proposal (proposal-id uint)) ...)
(define-read-only (get-proposal (proposal-id uint)) ...)
```

### Treasury Functions

```clarity
(define-read-only (get-treasury-balance) ...)
(define-public (donate-to-treasury (amount uint)) ...)
```

### Reputation System

```clarity
(define-read-only (get-member-reputation (user principal)) ...)
(define-public (decay-inactive-members) ...)
```

### Collaboration Functions

```clarity
(define-public (propose-collaboration (partner-dao principal)
                                    (proposal-id uint)) ...)
(define-public (accept-collaboration (collaboration-id uint)) ...)
```

## Error Codes

| Code   | Description        |
| ------ | ------------------ |
| `u100` | Not authorized     |
| `u101` | Already a member   |
| `u102` | Not a member       |
| `u103` | Invalid proposal   |
| `u104` | Proposal expired   |
| `u105` | Already voted      |
| `u106` | Insufficient funds |
| `u107` | Invalid amount     |

## Data Structures

### Member

```clarity
{
  reputation: uint,
  stake: uint,
  last-interaction: uint
}
```

### Proposal

```clarity
{
  creator: principal,
  title: (string-ascii 50),
  description: (string-utf8 500),
  amount: uint,
  yes-votes: uint,
  no-votes: uint,
  status: (string-ascii 10),
  created-at: uint,
  expires-at: uint
}
```

### Collaboration

```clarity
{
  partner-dao: principal,
  proposal-id: uint,
  status: (string-ascii 10)
}
```

## Key Mechanisms

### Voting Power Calculation

- Based on member's reputation and staked tokens
- Formula: `voting_power = (reputation * 10) + stake`

### Reputation System

- Initial reputation: 1 point
- Actions that increase reputation:
  - Creating proposals: +1 point
  - Voting: +1 point
  - Successful proposals: +5 points
  - Donations: +2 points
- Reputation decay: 50% after 30 days of inactivity

### Proposal Lifecycle

1. Creation (active status)
2. Voting period (1440 blocks ≈ 10 days)
3. Execution/Rejection based on votes
4. Status update (executed/rejected)

## Security Features

- Row-level authorization checks
- Principal-based access control
- Treasury balance validation
- Double-vote prevention
- Proposal expiration checks
- Collaboration verification

## Usage Examples

### Creating a Proposal

```clarity
(contract-call? .dao-governance create-proposal
  "Community Event Funding"
  "Fund the upcoming community meetup"
  u1000)
```

### Voting on a Proposal

```clarity
;; Vote yes on proposal #1
(contract-call? .dao-governance vote-on-proposal u1 true)
```

### Staking Tokens

```clarity
;; Stake 100 tokens
(contract-call? .dao-governance stake-tokens u100)
```

## Best Practices

1. **Membership Management**

   - Verify membership status before actions
   - Keep reputation scores updated
   - Monitor inactive members

2. **Proposal Creation**

   - Provide clear titles and descriptions
   - Set reasonable funding amounts
   - Consider voting period duration

3. **Treasury Operations**

   - Maintain sufficient balance for proposals
   - Regular balance monitoring
   - Safe unstaking procedures

4. **Collaboration**
   - Verify partner DAO authenticity
   - Clear collaboration objectives
   - Track collaboration status

