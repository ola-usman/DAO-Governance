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