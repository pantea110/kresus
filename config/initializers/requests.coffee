module.exports = (compound) ->

    #
    # Shared
    #
    {Bank, BankAccess, BankAccount, BankOperation, BankAlert} = compound.models

    all = (doc) ->
        emit doc.name, doc


    #
    # Bank
    #

    Bank.defineRequest "all", all, (err) ->
        if err
            compound.logger.write "Bank.All requests cannot be created"
            compound.logger.write err

    #
    # BankAccess
    #

    allByBank = (doc) ->
        emit doc.bank, doc

    BankAccess.defineRequest "all", all, (err) ->
        if err
            compound.logger.write "BankAccess.All requests cannot be created"
            compound.logger.write err

    BankAccess.defineRequest "allByBank", allByBank, (err) ->
        if err
            compound.logger.write "BankAccess.allByBank requests cannot be created"
            compound.logger.write err

    #
    # BankAcccount
    #

    allByBankAccess = (doc) ->
        emit doc.bankAccess, doc

    BankAccount.defineRequest "all", all, (err) ->
        if err
            compound.logger.write "BankAccount.All requests cannot be created"
            compound.logger.write err

    BankAccount.defineRequest "allByBankAccess", allByBankAccess, (err) ->
        if err
            compound.logger.write "BankAccount.allByBankAccess requests cannot be created"
            compound.logger.write err

    BankAccount.defineRequest "allByBank", allByBank, (err) ->
        if err
            compound.logger.write "BankAccount.allByBank requests cannot be created"
            compound.logger.write err

    #
    # BankOperation
    #

    allByBankAccount = (doc) ->
        emit doc.bankAccount, doc

    allByBankAccountAndDate = (doc) ->
        emit [doc.bankAccount, doc.date], doc

    allLike = (doc) ->
        emit [doc.bankAccount, doc.date, doc.amount, doc.title], doc

    BankOperation.defineRequest "all", all, (err) ->
        if err
            compound.logger.write "BankOperation.All requests cannot be created"
            compound.logger.write err

    BankOperation.defineRequest "allByBankAccount", allByBankAccountAndDate, (err) ->
        if err
            compound.logger.write "BankOperation.allByBankAccount requests cannot be created"
            compound.logger.write err

    BankOperation.defineRequest "allByBankAccountAndDate", allByBankAccountAndDate, (err) ->
        if err
            compound.logger.write "BankOperation.allByBankAccountAndDate requests cannot be created"
            compound.logger.write err

    BankOperation.defineRequest "allLike", allLike, (err) ->
        if err
            compound.logger.write "BankOperation.allLike requests cannot be created"
            compound.logger.write err


    #
    # BankAlert
    #

    allByBank = (doc) ->
        emit doc.bank, doc

    allByBankAccount = (doc) ->
        emit doc.bankAccount, doc

    BankAlert.defineRequest "all", all, (err) ->
        if err
            compound.logger.write "BankAlert.All requests cannot be created"
            compound.logger.write err

    BankAlert.defineRequest "allByBankAccount", allByBankAccount, (err) ->
        if err
            compound.logger.write "BankAlert.allByBankAccount requests cannot be created"
            compound.logger.write err
