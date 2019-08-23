# xrapid_search

Hunt for xRapid-like transactions out in the wild!

If you'd like to express your support:

![](img/xrptipbot.png) or ```rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv 71673368```


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
  xrapid_search.py [-t time] [-p] [(-s|-l)]
  xrapid_search.py -h | --help
  xrapid_search.py -v | --version

Options:
  -t time       Historical time period [default: 24].
                Valid values:
                  1 - 1 hour
                  24 - 24 hours
  -p            Plot the results in a chart.
  -s            Save results (xRapid.pickle).
  -l            Load results (xRapid.pickle)
  -v --version  Display version and exit.
  -h --help     Show this screen.
```


## Misc
