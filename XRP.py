from decimal import Decimal
from dateutil import parser
from dateutil.tz import tzutc
from datetime import datetime, timedelta, timezone
# Crypto APIs
from ripple_api import RippleDataAPIClient


def getPayments(src, dest, time):
    '''
    This function returns all XRP transactions on the XRPL from
    src addresses to dest addresses.

    Args:
        src: list of source addresses
        dest: list of destination addresses
        time: the historical span in hours.

    Returns:
        List of successful XRP Payment transactions
        from src to dest addresses.
    '''

    XRP_api = RippleDataAPIClient('https://data.ripple.com')

    # prepare for using the paging mechanism
    now = datetime.now(timezone.utc)
    begin = now - timedelta(hours=time)
    query_params = dict(currency='xrp', limit=1000, descending='true',
                        start=begin.strftime('%Y-%m-%dT%H:%M:%SZ'),
                        end=now.strftime('%Y-%m-%dT%H:%M:%SZ'))

    # fetch first page
    txs = XRP_api.get_payments(**query_params)
    res = [dict(dt=parser.parse(tx['executed_time']), dtag=tx['destination_tag'], amount=Decimal(tx['delivered_amount'])) \
           for tx in txs['payments'] if tx['source'] in src and tx['destination'] in dest]

    # fetch next pages until we hit the targeted historical span
    while 'marker' in txs:
        query_params['marker'] = txs['marker']
        txs = XRP_api.get_payments(**query_params)
        res.extend([dict(dt=parser.parse(tx['executed_time']), dtag=tx['destination_tag'], amount=Decimal(tx['delivered_amount'])) \
                    for tx in txs['payments'] if tx['source'] in src and tx['destination'] in dest])

    # sort by datetime
    res.sort(key=lambda x: x['dt'])
    return res