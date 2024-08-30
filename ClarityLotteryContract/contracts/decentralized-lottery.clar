;; Define constants
(define-constant TICKET_COST u100)  ;; Ticket cost is 100 microSTX
(define-constant MAX_PARTICIPANTS u200)  ;; Maximum number of participants

;; Storage variables
(define-data-var is-lottery-active bool true)  ;; State of the lottery
(define-data-var total-pot uint u0)  ;; Total amount of STX in the pot
(define-data-var lottery-participants (list 200 principal) (list))  ;; List of participants

;; Only the contract owner can end the lottery
(define-read-only (is-owner (sender principal))
    (is-eq sender tx-sender)
)

;; Enter the lottery
(define-public (enter-lottery)
    (let ((current-participants (var-get lottery-participants)))
        (begin
            ;; Check if the lottery is active
            (asserts! (var-get is-lottery-active) (err u1))
            
            ;; Check if the list is not full
            (asserts! (< (len current-participants) MAX_PARTICIPANTS) (err u3))
            
            ;; Check if the sent amount is equal to the ticket cost
            (asserts! (is-eq (stx-transfer? TICKET_COST tx-sender (as-contract tx-sender)) (ok true)) (err u2))
            
            ;; Add sender to the participants list
            (var-set lottery-participants 
                (concat current-participants (list tx-sender)))
            (var-set total-pot (+ (var-get total-pot) TICKET_COST))
            (ok u0)
        )
    )
)

;; Close the lottery and pick a winner
(define-public (end-lottery-and-select-winner)
    (begin
        ;; Only the contract owner can end the lottery
        (asserts! (is-owner tx-sender) (err u4))
        
        ;; Ensure the lottery is active
        (asserts! (var-get is-lottery-active) (err u5))
        
        ;; Ensure there are participants in the lottery
        (asserts! (> (len (var-get lottery-participants)) u0) (err u6))

        ;; Close the lottery
        (var-set is-lottery-active false)

        ;; Pick a random winner from the list of participants
        (let ((winner-index (random-int (len (var-get lottery-participants)))))
            (let ((selected-winner (unwrap-panic (element-at (var-get lottery-participants) winner-index))))
                (begin
                    ;; Transfer the pot to the winner
                    (try! (as-contract (stx-transfer? (var-get total-pot) tx-sender selected-winner)))
                    ;; Reset the lottery for the next round
                    (var-set lottery-participants (list))
                    (var-set total-pot u0)
                    (var-set is-lottery-active true)
                    (ok selected-winner)
                )
            )
        )
    )
)

;; Generate a pseudo-random integer based on block height and burn block height
(define-private (random-int (max-idx uint))
    (mod (+ block-height burn-block-height) max-idx)
)