;; Title: DAO Governance Smart Contract
;; Description: A comprehensive DAO governance system implementing membership management,
;; proposal creation and voting, treasury management, reputation tracking, and cross-DAO
;; collaboration features.

;; ======================
;; Constants
;; ======================

;; Access Control
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))

;; Membership Errors
(define-constant ERR-ALREADY-MEMBER (err u101))
(define-constant ERR-NOT-MEMBER (err u102))

;; Proposal Errors
(define-constant ERR-INVALID-PROPOSAL (err u103))
(define-constant ERR-PROPOSAL-EXPIRED (err u104))
(define-constant ERR-ALREADY-VOTED (err u105))

;; Financial Errors
(define-constant ERR-INSUFFICIENT-FUNDS (err u106))
(define-constant ERR-INVALID-AMOUNT (err u107))

;; ======================
;; Data Variables
;; ======================

(define-data-var total-members uint u0)
(define-data-var total-proposals uint u0)
(define-data-var treasury-balance uint u0)

;; ======================
;; Data Maps
;; ======================

;; Member Data Structure
(define-map members principal 
  {
    reputation: uint,
    stake: uint,
    last-interaction: uint
  }
)

;; Proposal Data Structure
(define-map proposals uint 
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
)

;; Voting Records
(define-map votes {proposal-id: uint, voter: principal} bool)

;; Cross-DAO Collaboration Records
(define-map collaborations uint 
  {
    partner-dao: principal,
    proposal-id: uint,
    status: (string-ascii 10)
  }
)

;; ======================
;; Private Functions
;; ======================

;; Membership Validation
(define-private (is-member (user principal))
  (match (map-get? members user)
    member-data true
    false
  )
)

;; Proposal Validation
(define-private (is-active-proposal (proposal-id uint))
  (match (map-get? proposals proposal-id)
    proposal (and 
      (< block-height (get expires-at proposal))
      (is-eq (get status proposal) "active")
    )
    false
  )
)

(define-private (is-valid-proposal-id (proposal-id uint))
  (match (map-get? proposals proposal-id)
    proposal true
    false
  )
)

(define-private (is-valid-collaboration-id (collaboration-id uint))
  (match (map-get? collaborations collaboration-id)
    collaboration true
    false
  )
)

;; Reputation Management
(define-private (calculate-voting-power (user principal))
  (let (
    (member-data (unwrap! (map-get? members user) u0))
    (reputation (get reputation member-data))
    (stake (get stake member-data))
  )
    (+ (* reputation u10) stake)
  )
)

(define-private (update-member-reputation (user principal) (change int))
  (match (map-get? members user)
    member-data 
    (let (
      (new-reputation (to-uint (+ (to-int (get reputation member-data)) change)))
      (updated-data (merge member-data {reputation: new-reputation, last-interaction: block-height}))
    )
      (map-set members user updated-data)
      (ok new-reputation)
    )
    ERR-NOT-MEMBER
  )
)
