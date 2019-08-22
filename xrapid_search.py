#!/usr/bin/python3

'''
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
'''
from docopt import docopt
import pickle
from XRP import getPayments
from exchanges import *
from search import getMatch, Print
from timeline import plotTimeline


if __name__ == '__main__':

    # Get cmdline arguments
    arguments = docopt(__doc__, version = 'xrapid_search 0.1')
    time = int(arguments.get('-t'))
    if time not in [1, 24]:
        print(__doc__)

    if not arguments.get('-l'):
        # Get transactions from APIs
        print('Getting trade history from Bitstamp...')
        print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
        res1 = getBitstamp(time=time)
        print('+ {} buy transactions in last {} hours'.format(len(['' for t in res1 if t['type'] == 'buy']), time))
        print('- {} sell transactions in last {} hours'.format(len(['' for t in res1 if t['type'] == 'sell']), time))
        print()

        print('Getting XRP ledger payments from Bitstamp to Bitso...')
        print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
        res2 = getPayments(src=ExchangeAddr['bitstamp'], dest=ExchangeAddr['bitso'], time=time)
        print('x {} payment transactions in last {} hours'.format(len(res2), time))
        print()

        print('Getting trade history from Bitso...')
        print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
        res3 = getBitso(time=time)
        print('+ {} buy transactions in last {} hours'.format(len(['' for t in res3 if t['type'] == 'buy']), time))
        print('- {} sell transactions in last {} hours'.format(len(['' for t in res3 if t['type'] == 'sell']), time))
        print()

        print('Searching...')
        print('~~~~~~~~~~~~')
        xRapid = getMatch(res1, res2, res3)
        Print(xRapid)
        # Save results
        if arguments.get('-s'):
            pickle.dump(xRapid, open('xRapid.pickle', 'wb'))

    else:
        # Load results from previous save
        xRapid = pickle.load(open('xRapid.pickle', 'rb'))

    # visualize the timeline
    if arguments.get('-p'):
        plotTimeline(xRapid)
