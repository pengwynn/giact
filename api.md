# Giact API #

## Authentication ##
	=> login
	=> logout


## Single Payment ##
	=> singlePayment(options)


## Create a new recurring payment ##
	=> recurringPayment(options)

### List recurring payment checks by an order or transaction ID ###
	=> listRecurringBy(key, id)
			=> listRecurringByOrder(id) < listRecurringBy
			=> listRecurringByTransation(id) < listRecurringBy

### Cancel future recurring payment checks by order or transaction ID ###
	=> cancelRecurringBy(key, id)
			=> cancelRecurringByOrder(id) < cancelRecurringBy
			=> cancelRecurringByTransaction(id) < cancelRecurringBy


## Create a new installment based payment, with initial amount and number of installments ##
	=> installmentPayment(options)

### List installment checks by order or transaction ID ###
	=> listInstallmentsBy(key, id)
			=> listInstallmentsByOrder(id) < listInstallmentsBy
			=> listInstallmentsByTransaction(id) < listInstallmentsBy

### Cancel future installment checks by order or transaction ID ###
	=> cancelInstallmentsBy(key, id)
			=> cancelInstallmentsByOrder(id) < cancelInstallmentsBy
 			=> cancelInstallmentsByTransaction(id) < cancelInstallmentsBy


## Cancel a transaction prior to batching by order or transaction ID ##
	=> cancelTransactionBy(key, id)
			=> cancelTransactionByOrder(id) < cancelTransactionBy
			=> cancelTransactionByTransaction(id) < cancelTransactionBy

## Statistical Reports ##
### List the summary for a given date ###
	=> dailySummary(date)

### List daily deposits for a given date ###
	=> dailyDeposits(date)

### List transactions scrubbed for a given date ###
	=> dailyScrubs(date)

### List errored transactions for a given date ###
	=> dailyErrors(date)

### List checks returned for a given date ###
	=> dailyReturns(date)

### List checks refunded for a given date ###
	=> dailyRefunds(date)

### List checks returned for a given date range ###
	=> rangeReturns(start, end)

### List checks refunded for a given date range ###
	=> rangeRefunds(start, end)

## Refunds ##

### Request a refund by order or transaction ID ###
	=> refundBy(key, id)
			=> refundByOrder(id) < refundBy
			=> refundByTransaction(id) < refundBy

### request a partial refund by order or transaction ID ###
	=> partialRefundBy(key, id)
			=> partialRefundByOrder(id) < partialRefundBy
			=> partialRefundByTransaction(id) < partialRefundBy


## Search Transactions ##
	=> listTransactionsBy(key, id)
			=> listTransactionsByOrder(id) < listTransactionsBy
			=> listTransactionsByCustomer(id) < listTransactionsBy
			=> listTransactionsByNameOnCheck(name) < listTransactionsBy
