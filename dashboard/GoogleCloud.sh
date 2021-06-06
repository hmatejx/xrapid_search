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
  CloseTime AS Time, CloseTimeTimestamp AS Timestamp,
  LedgerIndex, #Account, Destination,
  DestinationTag, #Fee,
  Amount,
  #CONCAT(xSource, "->", xDestination) AS xLeg,
  xSource, xDestination FROM
  (WITH
  Ledgers AS (
    SELECT LedgerIndex, CloseTime, CloseTimeTimestamp
    FROM xrpledgerdata.fullhistory.ledgers
  ),
  Exchanges AS (
    SELECT * FROM xRapid.Exchanges
  ),
  Transactions AS (
    SELECT #Account,
    xSource, #Destination,
    Name as xDestination, DestinationTag, #Fee,
    Amount, LedgerIndex
    FROM (
      SELECT Account,
      Name as xSource, Destination,
      DestinationTag, #Fee,
      AmountXRP / 1000000 as Amount, LedgerIndex, TransactionResult,
      FROM xrpledgerdata.fullhistory.transactions T1
      INNER JOIN Exchanges E ON T1.Account = E.Address
      WHERE
        AmountXRP IS NOT NULL
        AND TransactionType = "Payment"
        AND TransactionResult = "tesSUCCESS"
        AND LedgerIndex > 44092915
    ) T2
    INNER JOIN Exchanges E on T2.Destination = E.Address
  )
  SELECT
    CloseTime, CloseTimeTimestamp,
    Ledgers.LedgerIndex, #Destination, Account,
    DestinationTag, #Fee,
    Amount, xSource, xDestination
  FROM Ledgers
  LEFT OUTER JOIN Transactions
  ON Ledgers.LedgerIndex = Transactions.LedgerIndex
  WHERE
    xSource IS NOT NULL
    AND xDestination IS NOT NULL
    AND xSource <> xDestination
)
ORDER BY LedgerIndex DESC'

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
