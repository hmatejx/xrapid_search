#!/bin/bash

# configure according to your Google Cloud Platform setup
PROJECT='level-poetry-216906'
DATASET='xRapid'
TABLE='InterExchange'
GCSBUCKET='hmatejx_sandbox'

# executing the xRapid search query on Google BigQuery
echo
echo "1.) Executing the xRapid search query on Google BigQuery..."
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
bq query --nouse_legacy_sql --destination_table ${DATASET}.${TABLE} --replace --headless --format=none \
'SELECT
  CloseTime AS Time, CloseTimeTimestamp AS Timestamp, LedgerIndex, Account, Destination, DestinationTag, Fee, Amount,
  CONCAT(xSource, "->", xDestination) AS xLeg, xSource, xDestination FROM
(WITH
  Ledgers AS (
    SELECT LedgerIndex, CloseTime, CloseTimeTimestamp
    FROM xrpledgerdata.fullhistory.ledgers
  ),
  Exchanges AS (
    # Binance
    SELECT "rEb8TK3gBgk5auZkwc6sHnwrGVJH8DuaLh" AS Address, "Binance" as Name UNION ALL
    SELECT "rJb5KsHsDHF1YS5B5DU6QCkH5NsPaKQTcy" AS Address, "Binance" as Name UNION ALL
    SELECT "rEy8TFcrAPvhpKrwyrscNYyqBGUkE9hKaJ" AS Address, "Binance" as Name UNION ALL
    # BinanceUS
    SELECT "rEeEWeP88cpKUddKk37B2EZeiHBGiBXY3"  AS Address, "BinanceUS" as Name UNION ALL
    SELECT "rMvYS27SYs5dXdFsUgpvv1CSrPsCz7ePF5" AS Address, "BinanceUS" as Name UNION ALL
    # Bitbank
    SELECT "rLbKbPyuvs4wc1h13BEPHgbFGsRXMeFGL6" AS Address, "Bitbank" as Name UNION ALL
    SELECT "rw7m3CtVHwGSdhFjV4MyJozmZJv3DYQnsA" AS Address, "Bitbank" as Name UNION ALL
    SELECT "rwggnsfxvCmDb3YP9Hs1TaGvrPR7ngrn7Z" AS Address, "Bitbank" as Name UNION ALL
    # BitcoinTrade
    SELECT "r4ZQiz7r4vnM6tAMLu1NhxcDa7TNMdFLGt" AS Address, "BitcoinTrade" as Name UNION ALL
    # Bitfinex
    SELECT "rLW9gnQo7BQhU6igk5keqYnH3TVrCxGRzm" AS Address, "Bitfinex" as Name UNION ALL
    SELECT "rE3hWEGquaixF2XwirNbA1ds4m55LxNZPk" AS Address, "Bitfinex" as Name UNION ALL
    # Bithumb
    SELECT "rEtC4xAYJvtwDLJ9jZ4kHRHKbNoLLxSnfb" AS Address, "Bithumb" as Name UNION ALL
    SELECT "rPMM1dRp7taeRkbT74Smx2a25kTAHdr4N5" AS Address, "Bithumb" as Name UNION ALL
    SELECT "rNTkgxs5WG5mU5Sz26YoDVrHim5Y5ohC7"  AS Address, "Bithumb" as Name UNION ALL
    SELECT "r9hUMZBc3MWRc4YdsdZgNCW5Qef8wNSXpb" AS Address, "Bithumb" as Name UNION ALL
    SELECT "rD7XQw67JWBXuo2WPX2gZRsGKNsDUGTbx5" AS Address, "Bithumb" as Name UNION ALL
    SELECT "r9LHiNDZvpLoWPoKnbH2JWjFET8zoYT4Y5" AS Address, "Bithumb" as Name UNION ALL
    SELECT "rBF3GWchod3QL8TEYicwSeMu6sjXqKFaQ2" AS Address, "Bithumb" as Name UNION ALL
    SELECT "rDFCAUDVB5QhB61ETGT6tf8Rm1zBsj8LHU" AS Address, "Bithumb" as Name UNION ALL
    SELECT "rDxfhNRgCDNDckm45zT5ayhKDC4Ljm7UoP" AS Address, "Bithumb" as Name UNION ALL
    SELECT "rsdd66csGZkTzk42NDpJun7PNrGsC7WJHv" AS Address, "Bithumb" as Name UNION ALL
    # Bitkub
    SELECT "rpXTzCuXtjiPDFysxq8uNmtZBe9Xo97JbW" AS Address, "Bitkub" as Name UNION ALL
    # Bitstamp
    SELECT "rrpNnNLKrartuEqfJGpqyDwPj1AFPg9vn1" AS Address, "Bitstamp" as Name UNION ALL
    SELECT "rGFuMiw48HdbnrUbkRYuitXTmfrDBNTCnX" AS Address, "Bitstamp" as Name UNION ALL
    SELECT "rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv" AS Address, "Bitstamp" as Name UNION ALL
    SELECT "rvYAfWj5gh67oV6fW32ZzP3Aw4Eubs59B"  AS Address, "Bitstamp" as Name UNION ALL
    SELECT "rUobSiUpYH2S97Mgb4E7b7HuzQj2uzZ3aD" AS Address, "Bitstamp" as Name UNION ALL
    # Bitso
    SELECT "rG6FZ31hDHN1K5Dkbma3PSB5uVCuVVRzfn" AS Address, "Bitso" as Name UNION ALL
    SELECT "rHZaDC6tsGN2JWGeXhjKL6664RNCq5hu4B" AS Address, "Bitso" as Name UNION ALL
    SELECT "raXLsnnJVaLMDixEoXHXe56WQXKczbD8ub" AS Address, "Bitso" as Name UNION ALL
    SELECT "rGfGdVYLDSbji5mqfMvdpx4c8JyyfqVFgf" AS Address, "Bitso" as Name UNION ALL
    SELECT "rfEu1Wnr7LxStoFx8DBdzgr8M16FBUbH3K" AS Address, "Bitso" as Name UNION ALL
    SELECT "rLSn6Z3T8uCxbcd1oxwfGQN1Fdn5CyGujK" AS Address, "Bitso" as Name UNION ALL
    # Bittrex
    SELECT "rPVMhWBsfF9iMXYj3aAzJVkPDTFNSyWdKy" AS Address, "Bittrex" as Name UNION ALL
    SELECT "rE3sV9KSWeSiaAapsZGcSDfiFRSshK8Bqj" AS Address, "Bittrex" as Name UNION ALL
    # Braziliex ?
    # BTCMarkets
    SELECT "rU7xJs7QmjbiyxpEozNYUFQxaRD5kueY7z" AS Address, "BTCMarkets" as Name UNION ALL
    SELECT "r94JFtstbXmyG21h3RHKcNfkAHxAQ6HSGC" AS Address, "BTCMarkets" as Name UNION ALL
    SELECT "rL3ggCUKaiR1iywkGW6PACbn3Y8g5edWiY" AS Address, "BTCMarkets" as Name UNION ALL
    # BTCTurk
    SELECT "rNEygqkMv4Vnj8M2eWnYT1TDnV1Sc1X5SN" AS Address, "BTCTurk" as Name UNION ALL
    SELECT "rGmmsmyspyPsuBT4L5pLvAqTjxYqaFq4U5" AS Address, "BTCTurk" as Name UNION ALL
    # Bx.in.th
    SELECT "rp7Fq2NQVRJxQJvUZ4o8ZzsTSocvgYoBbs" AS Address, "Bx.in.th" as Name UNION ALL
    # CEX.io
    SELECT "rE1sdh25BJQ3qFwngiTBwaq3zPGGYcrjp1" AS Address, "CEX.io" as Name UNION ALL
    # Coinbase
    SELECT "rLNaPoKeeBjZe2qs6x52yVPZpZ8td4dc6w" AS Address, "Coinbase" as Name UNION ALL
    SELECT "rw2ciyaNshpHe7bCHo4bRWq6pqqynnWKQg" AS Address, "Coinbase" as Name UNION ALL
    # Coinbene
    SELECT "r9CcrhpV7kMcTu1SosKaY8Pq9g5XiiHLvS" AS Address, "Coinbene" as Name UNION ALL
    # Coinfield
    SELECT "rK7D3QnTrYdkp1fGKKzHFNXZpqN8dUCfaf" AS Address, "Coinfield" as Name UNION ALL
    # Coinone
    SELECT "rp2diYfVtpbgEMyaoWnuaWgFCAkqCAEg28" AS Address, "Coinone" as Name UNION ALL
    SELECT "rPsmHDMkheWZvbAkTA8A9bVnUdadPn7XBK" AS Address, "Coinone" as Name UNION ALL
    # Coins.Ph
    SELECT "rU2mEJSLqBRkYLVTv55rFTgQajkLTnT6mA" AS Address, "Coins.Ph" as Name UNION ALL
    # DCEX
    SELECT "r9W22DnkmktvdSdsdWS5CXJAxfWVRtbDD9" AS Address, "DCEX" as Name UNION ALL
    SELECT "rHXvKUCTzsu2CB8Y5tydaG7B2ABc4CCBYz" AS Address, "DCEX" as Name UNION ALL
    # Indodax
    SELECT "rDDrTcmnCxeTV1hycGdXiaEynYcU1QnSUg" AS Address, "Indodax" as Name UNION ALL
    SELECT "rwned6pcnAcJLZENGwWNMM7ccQsuqsfqqQ" AS Address, "Indodax" as Name UNION ALL
    SELECT "rwWr7KUZ3ZFwzgaDGjKBysADByzxvohQ3C" AS Address, "Indodax" as Name UNION ALL
    SELECT "rB46Pb2mxdCk2zn68MNwZnFQ7Wv2Kjtddr" AS Address, "Indodax" as Name UNION ALL
    # EXMO
    SELECT "rUocf1ixKzTuEe34kmVhRvGqNCofY1NJzV" AS Address, "EXMO" as Name UNION ALL
    SELECT "rUCjhpLHCcuwL1oyQfzPVeWHsjZHaZS6t2" AS Address, "EXMO" as Name UNION ALL
    SELECT "rsTv5cJK2EMJhYqUUni4sYBonVk7KqTxZg" AS Address, "EXMO" as Name UNION ALL
    SELECT "rLJPjRYGDVVEjv4VrJtouzqzyJ51YtdZKY" AS Address, "EXMO" as Name UNION ALL
    # IndepReserve
    SELECT "r33hypJXDs47LVpmvta7hMW9pR8DYeBtkW" AS Address, "IndepReserve" as Name UNION ALL
    # Kraken
    SELECT "rLHzPsX6oXkzU2qL12kHCH8G8cnZv1rBJh" AS Address, "Kraken" as Name UNION ALL
    # Liquid
    SELECT "rHQ6kEtVUPk6mK9XKnjRoudenoHzJ8ZL9p" AS Address, "Liquid" as Name UNION ALL
    SELECT "rMbWmirwEtRr7pNmhN4d4ysTMBvBxdvovs" AS Address, "Liquid" as Name UNION ALL
    # MercadoBitcoin
    SELECT "rnW8je5SsuFjkMSWkgfXvqZH3gLTpXxfFH" AS Address, "MercadoBitcoin" as Name UNION ALL
    SELECT "rHLndqCyNeEKY2PoDmSvUf5hVX5mgUZteB" AS Address, "MercadoBitcoin" as Name UNION ALL
    # Novadax
    SELECT "rE8aDxrPzx5Xqeppy2hgSXKppwNwpyEMbB" AS Address, "Novadax" as Name UNION ALL
    SELECT "rpfFaotCi4acV7HPFQsTfMJ4eE5ky8hucd" AS Address, "Novadax" as Name UNION ALL
    SELECT "rnKmNMJRFKckYEwaHYLVY9uaz5C313KjEh" AS Address, "Novadax" as Name UNION ALL
    SELECT "rHxtRRUMVAnPZUyRgXhRSyWZ2MrHx8AvVs" AS Address, "Novadax" as Name UNION ALL
    # Poloniex
    SELECT "rDCgaaSBAWYfsxUYhCk1n26Na7x8PQGmkq" AS Address, "Poloniex" as Name UNION ALL
    SELECT "rwU8rAiE2eyEPz3sikfbHuqCuiAtdXqa2v" AS Address, "Poloniex" as Name UNION ALL
    # SBI
    SELECT "rKcVYzVK1f4PhRFjLhWP7QmteG5FpPgRub" AS Address, "SBI" as Name UNION ALL
    SELECT "rDDyH5nfvozKZQCwiBrWfcE528sWsBPWET" AS Address, "SBI" as Name UNION ALL
    # Quidax
    SELECT "rMuC8SpD8GP5a1uXma2jZyHVY5wxeCK7bV" AS Address, "Quidax" as Name UNION ALL
    SELECT "rnNQs4WAKUHes7kJtqqRiU3Wq9q1pHuDEt" AS Address, "Quidax" as Name UNION ALL
    # Wazirx
    SELECT "rwuAm7XdcP3SBwgJrVthCvCzU7kETJUUit" AS Address, "Wazirx" as Name UNION ALL
    SELECT "rJXcrnAS8XoBwjvd5VrShrLMY8buPuiuC5" AS Address, "Wazirx" as Name UNION ALL
    # uknown
    SELECT "rKHZzzukdQeSateXEyiZrEbPr35qhskXp1" AS Address, "unknown" as Name
),
Transactions AS (
    SELECT Account, xSource, Destination, Name as xDestination, DestinationTag, Fee, Amount, LedgerIndex
    FROM (
      SELECT Account, Name as xSource, Destination, DestinationTag, Fee, AmountXRP / 1000000 as Amount, LedgerIndex, TransactionResult,
      FROM xrpledgerdata.fullhistory.transactions T1
      INNER JOIN Exchanges E ON T1.Account = E.Address
      WHERE
        AmountXRP IS NOT NULL
        AND TransactionType = "Payment"
        AND TransactionResult = "tesSUCCESS"
      # !!!
      # LIMIT 10000
    ) T2
    INNER JOIN Exchanges E on T2.Destination = E.Address
)
SELECT
  CloseTime, CloseTimeTimestamp, Ledgers.LedgerIndex, Destination, Account, DestinationTag, Fee, Amount, xSource, xDestination
FROM Ledgers
LEFT OUTER JOIN Transactions
ON Ledgers.LedgerIndex = Transactions.LedgerIndex
WHERE
  xSource IS NOT NULL
  AND xDestination IS NOT NULL
  AND xSource <> xDestination
)
ORDER BY LedgerIndex DESC, xLeg'

# extract the table to Google Cloud Storage
echo
echo "2.) Exporting the results to Google Cloud Storage..."
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
bq extract --destination_format=CSV --compression=GZIP ${DATASET}.${TABLE} gs://${GCSBUCKET}/${TABLE}.csv.gz

# download the resulting table from Google Cloud Storage
echo
echo "3.) Downloading the results..."
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
gsutil -m cp -r gs://${GCSBUCKET}/InterExchange.csv.gz .
gunzip -f ${TABLE}.csv.gz
echo

# add USD valuation
echo
echo "4.) Adding USD valuation..."
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~"
./valuation.py && rm InterExchange.csv
echo
