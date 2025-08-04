;; EduFund DAO Governance Token Contract
;; Clarity v2

;; Constants
(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-INSUFFICIENT-BALANCE u101)
(define-constant ERR-INSUFFICIENT-STAKED u102)
(define-constant ERR-MAX-SUPPLY-REACHED u103)
(define-constant ERR-PAUSED u104)
(define-constant ERR-ZERO-ADDRESS u105)

(define-constant TOKEN-NAME "EduFund Governance Token")
(define-constant TOKEN-SYMBOL "EDU")
(define-constant TOKEN-DECIMALS u6)
(define-constant MAX-SUPPLY u50000000) ;; 50M tokens

;; Variables
(define-data-var admin principal tx-sender)
(define-data-var paused bool false)
(define-data-var total-supply uint u0)

;; Maps
(define-map balances principal uint)
(define-map staked-balances principal uint)
(define-map delegations principal principal)
(define-map vote-power principal uint)

;; Private: only-admin
(define-private (only-admin)
  (is-eq tx-sender (var-get admin))
)

;; Private: not-paused
(define-private (not-paused)
  (asserts! (not (var-get paused)) (err ERR-PAUSED))
)

;; Admin: transfer ownership
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (only-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (not (is-eq new-admin 'SP000000000000000000002Q6VF78)) (err ERR-ZERO-ADDRESS))
    (var-set admin new-admin)
    (ok true)
  )
)

;; Admin: pause contract
(define-public (set-paused (pause bool))
  (begin
    (asserts! (only-admin) (err ERR-NOT-AUTHORIZED))
    (var-set paused pause)
    (ok pause)
  )
)

;; Minting (admin only)
(define-public (mint (recipient principal) (amount uint))
  (begin
    (asserts! (only-admin) (err ERR-NOT-AUTHORIZED))
    (asserts! (not (is-eq recipient 'SP000000000000000000002Q6VF78)) (err ERR-ZERO-ADDRESS))
    (let ((new-supply (+ (var-get total-supply) amount)))
      (asserts! (<= new-supply MAX-SUPPLY) (err ERR-MAX-SUPPLY-REACHED))
      (map-set balances recipient (+ amount (default-to u0 (map-get? balances recipient))))
      (var-set total-supply new-supply)
      (ok true)
    )
  )
)

;; Burning tokens
(define-public (burn (amount uint))
  (begin
    (not-paused)
    (let ((bal (default-to u0 (map-get? balances tx-sender))))
      (asserts! (>= bal amount) (err ERR-INSUFFICIENT-BALANCE))
      (map-set balances tx-sender (- bal amount))
      (var-set total-supply (- (var-get total-supply) amount))
      (ok true)
    )
  )
)

;; Transfer tokens
(define-public (transfer (recipient principal) (amount uint))
  (begin
    (not-paused)
    (asserts! (not (is-eq recipient 'SP000000000000000000002Q6VF78)) (err ERR-ZERO-ADDRESS))
    (let ((bal (default-to u0 (map-get? balances tx-sender))))
      (asserts! (>= bal amount) (err ERR-INSUFFICIENT-BALANCE))
      (map-set balances tx-sender (- bal amount))
      (map-set balances recipient (+ amount (default-to u0 (map-get? balances recipient))))
      (ok true)
    )
  )
)

;; Stake tokens (for governance)
(define-public (stake (amount uint))
  (begin
    (not-paused)
    (let ((bal (default-to u0 (map-get? balances tx-sender))))
      (asserts! (>= bal amount) (err ERR-INSUFFICIENT-BALANCE))
      (map-set balances tx-sender (- bal amount))
      (map-set staked-balances tx-sender (+ amount (default-to u0 (map-get? staked-balances tx-sender))))
      (ok true)
    )
  )
)

;; Unstake tokens
(define-public (unstake (amount uint))
  (begin
    (not-paused)
    (let ((staked (default-to u0 (map-get? staked-balances tx-sender))))
      (asserts! (>= staked amount) (err ERR-INSUFFICIENT-STAKED))
      (map-set staked-balances tx-sender (- staked amount))
      (map-set balances tx-sender (+ amount (default-to u0 (map-get? balances tx-sender))))
      (ok true)
    )
  )
)

;; Delegate vote power to another principal
(define-public (delegate (to principal))
  (begin
    (not-paused)
    (asserts! (not (is-eq to 'SP000000000000000000002Q6VF78)) (err ERR-ZERO-ADDRESS))
    (map-set delegations tx-sender to)
    (ok to)
  )
)

;; Read-onlys
(define-read-only (get-balance (owner principal))
  (ok (default-to u0 (map-get? balances owner)))
)

(define-read-only (get-staked (owner principal))
  (ok (default-to u0 (map-get? staked-balances owner)))
)

(define-read-only (get-total-supply)
  (ok (var-get total-supply))
)

(define-read-only (get-admin)
  (ok (var-get admin))
)

(define-read-only (get-delegate (delegator principal))
  (ok (map-get? delegations delegator))
)

(define-read-only (is-paused)
  (ok (var-get paused))
)

(define-read-only (get-token-meta)
  (ok {
    name: TOKEN-NAME,
    symbol: TOKEN-SYMBOL,
    decimals: TOKEN-DECIMALS,
    max-supply: MAX-SUPPLY
  })
)
