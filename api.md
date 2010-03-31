# Giact Api #

## Authentication ##
	-> login
	-> logout


## Single Payment ##
	-> single_payment(options)


## Create a New Recurring Payment ##
	-> recurring_payment(options)
		-> recurring_payments < recurring_payment

### List Recurring Payment Checks by an Order or Transaction Id ###
	-> list_recurring_by(key, id)
			-> list_recurring_by_order(id) < list_recurring_by
			-> list_recurring_by_transation(id) < list_recurring_by

### Cancel Future Recurring Payment Checks by Order or Transaction Id ###
	-> cancel_recurring_by(key, id)
			-> cancel_recurring_by_order(id) < cancel_recurring_by
			-> cancel_recurring_by_transaction(id) < cancel_recurring_by


## Create a New Installment Based Payment, With Initial Amount and Number of Installments ##
	-> installment_payment(options)

### List Installment Checks by Order or Transaction Id ###
	-> list_installments_by(key, id)
			-> list_installments_by_order(id) < list_installments_by
			-> list_installments_by_transaction(id) < list_installments_by

### Cancel Future Installment Checks by Order or Transaction Id ###
	-> cancel_installments_by(key, id)
			-> cancel_installments_by_order(id) < cancel_installments_by
 			-> cancel_installments_by_transaction(id) < cancel_installments_by


## Cancel a Transaction Prior to Batching by Order or Transaction Id ##
	-> cancel_transaction_by(key, id)
			-> cancel_transaction_by_order(id) < cancel_transaction_by
			-> cancel_transaction_by_transaction(id) < cancel_transaction_by

## Refunds ##

### Request a Refund by Order or Transaction Id ###
	-> refund_by(key, id)
			-> refund_by_order(id) < refund_by
			-> refund_by_transaction(id) < refund_by

### Request a Partial Refund by Order or Transaction Id ###
	-> partial_refund_by(key, id)
			-> partial_refund_by_order(id) < partial_refund_by
			-> partial_refund_by_transaction(id) < partial_refund_by



## Statistical Reports ##
### List the Summary for a Given Date ###
	=> daily_summary(date)

### List Daily Deposits for a Given Date ###
	=> daily_deposits(date)

### List Transactions Scrubbed for a Given Date ###
	=> daily_scrubs(date)

### List Errored Transactions for a Given Date ###
	=> daily_errors(date)

### List Checks Returned for a Given Date ###
	=> daily_returns(date)

### List Checks Refunded for a Given Date ###
	=> daily_refunds(date)

### List Checks Returned for a Given Date Range ###
	=> range_returns(start, end)

### List Checks Refunded for a Given Date Range ###
	=> range_refunds(start, end)


## Search Transactions ##
	=> list_transactions_by(key, id)
			=> list_transactions_by_order(id) < list_transactions_by
			=> list_transactions_by_customer(id) < list_transactions_by
			=> list_transactions_by_name_on_check(name) < list_transactions_by
