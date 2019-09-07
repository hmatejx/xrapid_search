# xrapid_search

Hunt for xRapid-like transactions out in the wild!

If you'd like to express your support:

![](img/xrptipbot.png) or `rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv 71673368`


## Install

Make sure you have installed the pip packages: `python-ripple-lib`, `bitso-py`, `docopt`, `numpy`, `matplotlib`, and [this modified version](https://github.com/hmatejx/bitstamp-python-client) of `BitstampClient`.

Alternatively, you can set up a project-specific virtual environment as shown below.

```
# virtualenv venv --python=python3
# . venv/bin/activate
# pip install -r requirements.txt
```

Just be aware that in order to get matplotlib working (used for plotting the timeline) in a virtual environment, you might still need to rely on presence of system-wide packages, e.g. python3-tk and tk-dev.

## Running

```
python xrapid_search.py -t 24
Getting trade history from Bitstamp...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ 3195 buy transactions in last 24 hours
- 1758 sell transactions in last 24 hours

Getting XRP ledger payments from Bitstamp to Bitso...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
x 52 payment transactions in last 24 hours

Getting trade history from Bitso...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ 393 buy transactions in last 24 hours
- 307 sell transactions in last 24 hours

Searching...
~~~~~~~~~~~~
xRAPID transaction!
 1.  Bitstamp   USDXRP      39196.89 XRP     10701 USD  at  2019-08-22T13:23:13
 2.  - XRPL -   25370527    39196.89 XRP                at  2019-08-22T13:23:42  (Δt = 29.0, ΔA = -0.00)
 3.  Bitso      XRPMXN      39198.67 XRP    210105 MXN  at  2019-08-22T13:24:01  (Δt = 19.0, ΔA = 1.79)
...
```

## Options

Currently avaliable options.

```
python xrapid_search.py -h
Usage:
  xrapid_search.py [-t time] [-p] [-l]
  xrapid_search.py -h | --help
  xrapid_search.py -v | --version

Options:
  -t time       Historical time period [default: 24].
                Valid settings for time are:
                  1 - 1 hour
                  24 - 24 hours
  -p            Plot the results in a chart.
  -l            Load results (xRapid.pickle), implies -p.
  -v --version  Display version and exit.
  -h --help     Show this screen.
```


## Creating visualization dashboards

I'm [semi-regularly publishing](https://public.tableau.com/profile/hmatejx#!/vizhome/xRapid_search/xRapidtrafficTag) inter-exchange traffic data that follows the xRapid pattern.

If you would like to perform your own investigations, I have prepared a script called `GoogleCloud.sh` in the `dashboard` folder, which

- executes the xRapid search query on Google BigQuery,
- exports the results to a Google Cloud Storage bucket,
- and downloads the data to a local CSV file.

If you want to use the script, you must create your own [Google Cloud Platform](https://console.cloud.google.com/) project and enable billing (don't worry, for such casual use it should be free). Go to BigQuery and create an empty dataset for your project, i.e. named `xRapid`.

Next, you need an environment with `gsutil` [installed and configured](https://cloud.google.com/storage/docs/gsutil_install). 
Also, you should create a bucket on Google Cloud Storage (instead of `us-east1` in the example below use your own favorite zone):
```
gsutil mb -l us-east1 gs://my-awesome-bucket/
```


When you have all the prerequisites, modify the following variables at the top of the script according to your setup:

```
PROJECT='level-poetry-216906' # name of the GCP project
DATASET='xRapid'              # name of the project dataset
TABLE='InterExchange'         # name the table holding query results
GCSBUCKET='hmatejx_sandbox'   # GCS bucket holding exported data
```

Running the script should produce an output like this:

```
$ ./GoogleCloud.sh

1.) Executing the xRapid search query on Google BigQuery...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Waiting on bqjob_r119aa6c8296044b3_0000016d0bde6b20_1 ... (5s) Current status: DONE


2.) Exporting the results to Google Cloud Storage...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Waiting on bqjob_r1ac9d808abfe15c4_0000016d0bde915c_1 ... (5s) Current status: DONE

3.) Downloading the results...
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Copying gs://hmatejx_sandbox/InterExchange.csv.gz...
- [1/1 files][  4.5 MiB/  4.5 MiB] 100% Done

Operation completed over 1 objects/4.5 MiB.
```

The resulting data set has the following structure:
```
$ head InterExchange.csv | column -t -s,
Time                 Timestamp  LedgerIndex  Account                             Destination                         SourceTag   DestinationTag  Fee           Amount              xLeg      xSource   xDestination
2019-09-07 09:25:21  621170721  49872164     rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv  rPVMhWBsfF9iMXYj3aAzJVkPDTFNSyWdKy  653337620   60000           741458        Bitstamp->Bittrex   Bitstamp  Bittrex
2019-09-07 09:06:21  621169581  49871867     rPVMhWBsfF9iMXYj3aAzJVkPDTFNSyWdKy  rU2mEJSLqBRkYLVTv55rFTgQajkLTnT6mA  113326      12              44.002406     Bittrex->Coins.ph   Bittrex   Coins.ph
2019-09-07 07:16:51  621163011  49870174     rU2mEJSLqBRkYLVTv55rFTgQajkLTnT6mA  rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv  32618391    45              113.616       Coins.ph->Bitstamp  Coins.ph  Bitstamp
2019-09-07 07:10:30  621162630  49870074     rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv  rU2mEJSLqBRkYLVTv55rFTgQajkLTnT6mA  5           60000           9899.32       Bitstamp->Coins.ph  Bitstamp  Coins.ph
2019-09-07 04:00:41  621151241  49867132     rU2mEJSLqBRkYLVTv55rFTgQajkLTnT6mA  rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv  48170618    45              5547.879955   Coins.ph->Bitstamp  Coins.ph  Bitstamp
2019-09-07 03:36:30  621149790  49866761     rPVMhWBsfF9iMXYj3aAzJVkPDTFNSyWdKy  rLSn6Z3T8uCxbcd1oxwfGQN1Fdn5CyGujK  71367866    12              420.300869    Bittrex->Bitso      Bittrex   Bitso
2019-09-07 03:36:20  621149780  49866758     rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv  rPVMhWBsfF9iMXYj3aAzJVkPDTFNSyWdKy  1208977612  60000           94651         Bitstamp->Bittrex   Bitstamp  Bittrex
2019-09-07 03:26:50  621149210  49866612     rU2mEJSLqBRkYLVTv55rFTgQajkLTnT6mA  rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv  48170618    45              17757.569955  Coins.ph->Bitstamp  Coins.ph  Bitstamp
2019-09-07 02:24:42  621145482  49865656     rPVMhWBsfF9iMXYj3aAzJVkPDTFNSyWdKy  rU2mEJSLqBRkYLVTv55rFTgQajkLTnT6mA  130150      12              375           Bittrex->Coins.ph   Bittrex   Coins.ph
```
