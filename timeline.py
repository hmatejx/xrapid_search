from datetime import datetime
from dateutil.tz import tzutc
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import numpy as np
import matplotlib.dates as mdates


def plotTimeline(xRapid):

    # Check if received empty list
    if not len(xRapid):
        print('No data to plot')
        return

    # Source exchange
    res1 = [x[0] for x in xRapid]
    d1 = [tr['dt'] for tr in res1]
    n1 = ['{:.2f} ({:.0f} USD)'.format(tr['amount'], tr['amount']*tr['price']) for tr in res1]

    # XRPL
    res2 = [x[1] for x in xRapid]
    d2 = [tr['dt'] for tr in res2]
    n2 = ['{:.2f}'.format(tr['amount']) for tr in res2]
    t2 = ['DT:'+str(tr['dtag']) for tr in res2]

    # Destination exchange
    res3 = [x[2] for x in xRapid]
    d3 = [tr['dt'] for tr in res3]
    n3 = ['{:.2f} ({:.0f} MXN)'.format(tr['amount'], tr['amount']*tr['price']) for tr in res3]

    # Display activity summary
    print('Summary:')
    print('~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')
    print('Total USD sold:        {:.2f}'.format(sum([x['amount']*x['price'] for x in res1])))
    print('Total XRP transferred: {:.2f}'.format(sum([x['amount'] for x in res2])))
    print('Total MXN bought:      {:.2f}'.format(sum([x['amount']*x['price'] for x in res3])))

    # Create figure and plot a stem plot with the date
    fig, ax = plt.subplots(figsize=(19, 5), constrained_layout=True)
    for tick in ax.xaxis.get_major_ticks():
        tick.label.set_fontsize(8)
    l1 = np.tile([1, 0.75, 1, 0.75, 1, 0.75], int(np.ceil(len(d1)/6)))[:len(d1)]
    markerline1, stemline1, baseline1 = ax.stem(d1, l1, linefmt="k-", basefmt=" ")

    l2 = np.tile([0, 0, 0, 0, 0, 0], int(np.ceil(len(d2)/6)))[:len(d2)]
    markerline2, stemline2, baseline2 = ax.stem(d2, l2, linefmt="C3-", basefmt=" ")

    l3 = np.tile([-1, -0.75, -1, -0.75, -1, -0.75], int(np.ceil(len(d3)/6)))[:len(d3)]
    markerline3, stemline3, baseline3 = ax.stem(d3, l3, linefmt="C3-", basefmt=" ")

    # Format
    ax.get_xaxis().set_major_locator(mdates.MinuteLocator(interval=10))
    ax.get_xaxis().set_major_formatter(mdates.DateFormatter('%Y-%m-%dT%H:%M:%S', tzutc()))
    ax.axhline(y=0, color='k', linestyle='--', linewidth=0.5)
    plt.setp(ax.get_xticklabels(), rotation=90, ha="right")
    plt.setp(markerline1, mec="k", mfc="w", zorder=3)
    plt.setp(markerline2, mec="b", mfc="b", zorder=3)
    plt.setp(markerline3, mec="r", mfc="w", zorder=3)
    plt.setp(stemline1, 'linewidth', 0.75)
    plt.setp(stemline2, 'linewidth', 0.75)
    plt.setp(stemline3, 'linewidth', 0.75)
    plt.setp(baseline1, 'linewidth', 0.5)
    plt.setp(baseline2, 'linewidth', 0.5)
    plt.setp(baseline3, 'linewidth', 0.5)

    # Annotate lines
    for d, l, r in zip(d1, l1, n1):
        ax.annotate(r, xy=(d, l + 0.1), xytext=(-3, np.sign(l)*3),
                    textcoords="offset points", va='bottom', ha="left", fontsize=8, rotation=45)
    for d, l, r in zip(d2, l2, n2):
        ax.annotate(r, xy=(d, l + 0.1), xytext=(-3, np.sign(l)*3),
                    textcoords="offset points", va='bottom', ha="left", color='b', fontsize=8, rotation=45)
    for d, l, r in zip(d2, l2, t2):
        ax.annotate(r, xy=(d, l - 0.1), xytext=(-3, np.sign(l)*3),
                    textcoords="offset points", va='top', ha="right", color='b', fontsize=8, rotation=45)
    for d, l, r in zip(d3, l3, n3):
        ax.annotate(r, xy=(d, l - 0.1), xytext=(-3, np.sign(l)*3),
                    textcoords="offset points", va='top', ha="right", color='r', fontsize=8, rotation=45)

    # Remove y axis and spines
    ax.get_yaxis().set_visible(False)
    for spine in ["left", "top", "right"]:
        ax.spines[spine].set_visible(False)

    ax.margins(y=0.8)
    plt.show()
