# This modules mocks output generated by weboob. It is activated if NODE_ENV is
# not set or set to 'development'. (see top of weboob-manager.coffee)
moment = require 'moment'

banks = require '../../../weboob/banks-all.json'

hashAccount = (uuid) ->
    hash = uuid.charCodeAt(0) + uuid.charCodeAt(3) + uuid.charCodeAt(1)
    return {
        main: hash + '1'
        second: hash + '2'
        third: hash + '3'
    }


exports.FetchAccounts = (bankuuid, login, password, website, callback) ->
    output = {}

    obj = hashAccount bankuuid
    {main, second, third} = obj

    output[bankuuid] = [
        {
            "accountNumber": main,
            "label": "Compte bancaire",
            "balance": "150"
        },
        {
            "accountNumber": second,
            "label": "Livret A",
            "balance": "500"
        },
        {
            "accountNumber": third,
            "label": "Plan Epargne Logement",
            "balance": "0"
        }
    ]

    if Math.random > .8
        output[bankuuid].append(
            "accountNumber": "0147200001",
            "label": "Assurance vie",
            "balance": "1000"
        )

    callback null, output



randomLabels = [
    ['Café Moxka', 'Petit expresso rapido Café Moxka'],
    ['MerBnB', 'Paiement en ligne MerBNB'],
    ['Tabac Debourg', 'Bureau de tabac SARL Clopi Cloppa'],
    ['Rapide PSC', 'Paiement sans contact Rapide'],
    ['MacDollars PSC', 'Paiement sans contact Macdollars'],
    ['FNAK', 'FNAK CB blabla'],
    ['CB Sefaurat', 'Achat de parfum chez Sefaurat'],
    ['Polyprix CB', 'Courses chez Polyprix'],
    ['Croisement CB', 'Courses chez Croisement'],
    ['PRLV UJC', 'PRLV UJC'],
    ['CB Spotifaille', 'CB Spotifaille London'],
    ['Antiquaire', 'Antiquaire'],
    ['Le Perroquet Bourré', 'Le Perroquet Bourré SARL'],
    ['Le Vol de Nuit', 'Bar Le Vol De Nuit SARL'],
    ['Impots fonciers', 'Prelevement impots fonciers numero reference 47839743892 client 43278437289'],
    ['ESPA Carte Hassan Cehef', 'Paiement carte Hassan Cehef'],
    ['Indirect Energie', 'ESPA Indirect Energie SARL'],
    ['', 'VIR Mr Jean Claude Dusse'],
]

randomLabelsPositive = [
    ['VIR Nuage Douillet', 'VIR Nuage Douillet REFERENCE Salaire'],
    ['Impots', 'Remboursement impots en votre faveur'],
    ['', 'VIR Pots de vin et magouilles pas claires'],
    ['Case départ', 'Passage par la case depart'],
]

rand = (low, high) ->
    return low + (Math.random() * (high - low) | 0)

randomLabel = () ->
    return randomLabels[rand 0, randomLabels.length]

randomLabelPositive = () ->
    return randomLabelsPositive[rand 0, randomLabelsPositive.length]

generateDate = (low, high) ->
    moment().date(rand(low, high)).format('YYYY-MM-DDT00:00:00.000[Z]')

generateOne = (account) ->
    n = rand 0, 100

    if n < 2
        # on 4th of Month
        return {
            "label": "Loyer"
            "raw": "Loyer habitation"
            "amount": "-300"
            "rdate": generateDate 4, 4
            "account": account
        }

    if n < 15
        [label, raw] = randomLabelPositive()
        amount = rand(100, 800) + rand(0, 100) / 100
        rdate = generateDate 0, moment().date()
        return {
            label: label
            raw: raw
            amount: amount.toString()
            rdate: rdate
            account: account
        }

    [label, raw] = randomLabel()
    amount = -rand(0, 60) + rand(0, 100) / 100
    rdate = generateDate 0, moment().date()
    return {
        label: label
        raw: raw
        amount: amount.toString()
        rdate: rdate
        account: account
    }

selectRandomAccount = (uuid) ->
    n = rand 0, 100
    accounts = hashAccount uuid
    if n < 90
        return accounts.main
    if n < 95
        return accounts.second
    return accounts.third

generate = (uuid) ->
    operations = []
    count = 3
    i = count
    while i--
        operations.push generateOne selectRandomAccount uuid
        count++
    while rand(0, 100) > 70 and count < 8
        operations.push generateOne selectRandomAccount uuid
        count++
    console.log 'generated', count, 'operations'
    operations

exports.FetchOperations = (bankuuid, login, password, website, callback) ->
    output = {}
    output[bankuuid] = generate bankuuid
    callback null, output
