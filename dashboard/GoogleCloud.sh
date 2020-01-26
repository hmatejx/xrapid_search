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
  CloseTime AS Time, CloseTimeTimestamp AS Timestamp, LedgerIndex, Account, Destination, SourceTag, DestinationTag, Fee, Amount,
  CONCAT(xSource, "->", xDestination) AS xLeg, xSource, xDestination FROM
(WITH
  Ledgers AS (
    SELECT LedgerIndex, CloseTime, CloseTimeTimestamp
    FROM xrpledgerdata.fullhistory.ledgers
  ),
  Transactions AS (
    SELECT Account, Destination, SourceTag, DestinationTag, Fee, TransactionType, AmountXRP / 1000000 as Amount, LedgerIndex, TransactionResult,
    CASE
      WHEN Account IN ("rrpNnNLKrartuEqfJGpqyDwPj1AFPg9vn1", "rGFuMiw48HdbnrUbkRYuitXTmfrDBNTCnX", "rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv", "rvYAfWj5gh67oV6fW32ZzP3Aw4Eubs59B", "rUobSiUpYH2S97Mgb4E7b7HuzQj2uzZ3aD") THEN "Bitstamp"
      WHEN Account IN ("rPVMhWBsfF9iMXYj3aAzJVkPDTFNSyWdKy", "rE3sV9KSWeSiaAapsZGcSDfiFRSshK8Bqj") THEN "Bittrex"
      WHEN Account IN ("rG6FZ31hDHN1K5Dkbma3PSB5uVCuVVRzfn", "rHZaDC6tsGN2JWGeXhjKL6664RNCq5hu4B", "raXLsnnJVaLMDixEoXHXe56WQXKczbD8ub", "rGfGdVYLDSbji5mqfMvdpx4c8JyyfqVFgf", "rfEu1Wnr7LxStoFx8DBdzgr8M16FBUbH3K", "rLSn6Z3T8uCxbcd1oxwfGQN1Fdn5CyGujK") THEN "Bitso"
      WHEN Account IN ("rU2mEJSLqBRkYLVTv55rFTgQajkLTnT6mA") THEN "Coins.ph"
      WHEN Account IN ("rLNaPoKeeBjZe2qs6x52yVPZpZ8td4dc6w", "rw2ciyaNshpHe7bCHo4bRWq6pqqynnWKQg") THEN "Coinbase"
      WHEN Account IN ("rU7xJs7QmjbiyxpEozNYUFQxaRD5kueY7z", "r94JFtstbXmyG21h3RHKcNfkAHxAQ6HSGC", "rL3ggCUKaiR1iywkGW6PACbn3Y8g5edWiY") THEN "BTCMarkets"
      WHEN Account IN ("rnW8je5SsuFjkMSWkgfXvqZH3gLTpXxfFH", "rHLndqCyNeEKY2PoDmSvUf5hVX5mgUZteB") THEN "MercadoBitcoin"
      WHEN Account IN ("r4ZQiz7r4vnM6tAMLu1NhxcDa7TNMdFLGt") THEN "BitcoinTrade"
      WHEN Account IN ("rLHzPsX6oXkzU2qL12kHCH8G8cnZv1rBJh") THEN "Kraken"
      WHEN Account IN ("rEb8TK3gBgk5auZkwc6sHnwrGVJH8DuaLh", "rJb5KsHsDHF1YS5B5DU6QCkH5NsPaKQTcy", "rEy8TFcrAPvhpKrwyrscNYyqBGUkE9hKaJ") THEN "Binance"
      WHEN Account IN ("rwWr7KUZ3ZFwzgaDGjKBysADByzxvohQ3C") THEN "Indodax"
      WHEN Account IN ("rDCgaaSBAWYfsxUYhCk1n26Na7x8PQGmkq") THEN "Poloniex"
      WHEN Account IN ("rNEygqkMv4Vnj8M2eWnYT1TDnV1Sc1X5SN", "rGmmsmyspyPsuBT4L5pLvAqTjxYqaFq4U5") THEN "BTCTurk"
      WHEN Account IN ("rKHZzzukdQeSateXEyiZrEbPr35qhskXp1") THEN "Unknown"
      ELSE NULL
    END AS xSource,
    CASE
      WHEN Destination IN ("rrpNnNLKrartuEqfJGpqyDwPj1AFPg9vn1", "rGFuMiw48HdbnrUbkRYuitXTmfrDBNTCnX", "rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv", "rvYAfWj5gh67oV6fW32ZzP3Aw4Eubs59B", "rUobSiUpYH2S97Mgb4E7b7HuzQj2uzZ3aD") THEN "Bitstamp"
      WHEN Destination IN ("rPVMhWBsfF9iMXYj3aAzJVkPDTFNSyWdKy", "rE3sV9KSWeSiaAapsZGcSDfiFRSshK8Bqj") THEN "Bittrex"
      WHEN Destination IN ("rG6FZ31hDHN1K5Dkbma3PSB5uVCuVVRzfn", "rHZaDC6tsGN2JWGeXhjKL6664RNCq5hu4B", "raXLsnnJVaLMDixEoXHXe56WQXKczbD8ub", "rGfGdVYLDSbji5mqfMvdpx4c8JyyfqVFgf", "rfEu1Wnr7LxStoFx8DBdzgr8M16FBUbH3K", "rLSn6Z3T8uCxbcd1oxwfGQN1Fdn5CyGujK") THEN "Bitso"
      WHEN Destination IN ("rU2mEJSLqBRkYLVTv55rFTgQajkLTnT6mA") THEN "Coins.ph"
      WHEN Destination IN ("rLNaPoKeeBjZe2qs6x52yVPZpZ8td4dc6w", "rw2ciyaNshpHe7bCHo4bRWq6pqqynnWKQg") THEN "Coinbase"
      WHEN Destination IN ("rU7xJs7QmjbiyxpEozNYUFQxaRD5kueY7z", "r94JFtstbXmyG21h3RHKcNfkAHxAQ6HSGC", "rL3ggCUKaiR1iywkGW6PACbn3Y8g5edWiY") THEN "BTCMarkets"
      WHEN Destination IN ("rnW8je5SsuFjkMSWkgfXvqZH3gLTpXxfFH", "rHLndqCyNeEKY2PoDmSvUf5hVX5mgUZteB") THEN "MercadoBitcoin"
      WHEN Destination IN ("r4ZQiz7r4vnM6tAMLu1NhxcDa7TNMdFLGt") THEN "BitcoinTrade"
      WHEN Destination IN ("rLHzPsX6oXkzU2qL12kHCH8G8cnZv1rBJh") THEN "Kraken"
      WHEN Destination IN ("rEb8TK3gBgk5auZkwc6sHnwrGVJH8DuaLh", "rJb5KsHsDHF1YS5B5DU6QCkH5NsPaKQTcy", "rEy8TFcrAPvhpKrwyrscNYyqBGUkE9hKaJ") THEN "Binance"
      WHEN Destination IN ("rwWr7KUZ3ZFwzgaDGjKBysADByzxvohQ3C") THEN "Indodax"
      WHEN Destination IN ("rDCgaaSBAWYfsxUYhCk1n26Na7x8PQGmkq") THEN "Poloniex"
      WHEN Destination IN ("rNEygqkMv4Vnj8M2eWnYT1TDnV1Sc1X5SN", "rGmmsmyspyPsuBT4L5pLvAqTjxYqaFq4U5") THEN "BTCTurk"
      WHEN Destination IN ("rKHZzzukdQeSateXEyiZrEbPr35qhskXp1") THEN "Unknown"
      ELSE NULL
    END AS xDestination
    FROM xrpledgerdata.fullhistory.transactions
    WHERE
      AmountXRP IS NOT NULL
      AND TransactionType = "Payment"
      AND TransactionResult = "tesSUCCESS"
  )
SELECT
  CloseTime, CloseTimeTimestamp, Ledgers.LedgerIndex, Destination, Account, DestinationTag, SourceTag, Fee, TransactionType, Amount, TransactionResult, xSource, xDestination
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
