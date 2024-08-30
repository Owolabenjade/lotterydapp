;; Define constants
(define-constant TICKET_COST u100)  ;; ticket cost is 100 microSTX

;; Storage variables
(define-data-var is-lottery-active bool true)  ;; state of the lottery
(define-data-var total-pot uint u0)  ;; total amount of STX in the pot
(define-data-var lottery-participants (list 200 principal))  ;; list of participants, max 200 entries

;; Enter the lottery
(define-public (enter-lottery)
    (begin
        ;; Check if the lottery is active
        (asserts! (eq? (var-get is-lottery-active) true) (err u1))
        
        ;; Check if the sent amount is equal to the ticket cost
        (asserts! (is-eq? stx-transfer? TICKET_COST tx-sender (as-contract tx-sender)) (err u2))
        
        ;; Add sender to the participants list
        (let ((current-participants (var-get lottery-participants)))
            (if (is-eq (len current-participants) 200)
                (err u3)  ;; if the list is full, return error
                (begin
                    (var-set lottery-participants (append current-participants tx-sender))
                    (var-set total-pot (+ (var-get total-pot) TICKET_COST))
                    (ok u0)
                )
            )
        )
    )
)

;; Close the lottery and pick a winner
(define-public (end-lottery-and-select-winner)
    (begin
        ;; Only end if lottery is active
        (asserts! (eq? (var-get is-lottery-active) true) (err u4))
        
        ;; End the lottery
        (var-set is-lottery-active false)

        ;; Pick a random winner from the list of participants
        (let ((winner-index (random (len (var-get lottery-participants)))))
            (let ((selected-winner (element-at (var-get lottery-participants) winner-index)))
                (begin
                    ;; Transfer the pot to the winner
                    (stx-transfer? (var-get total-pot) (as-contract tx-sender) selected-winner)
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

;; Auxiliary function to generate a pseudo-random index based on the block height
(define-private (random (max-idx uint))
    (mod (+ block-height (fold + u0 (var-get lottery-participants))) max-idx)
)
