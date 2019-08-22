from decimal import Decimal
from dateutil.tz import tzutc
from datetime import datetime, timedelta, timezone
# Crypto APIs
import bitstamp.client
import bitso
# There are also APIs for other exchanges available
#  - Bittrex:  https://bittrex.github.io/api/v3
#  - Coins.Ph: https://pro.coins.asia/coins-pro-api/
#              (unfortunately no trades endpoint are available, therefore
#               monitoring the USD→PHP corridor is not yet possible)
#


# The list of known exchange addresses
ExchangeAddr = {'bitstamp': ['rrpNnNLKrartuEqfJGpqyDwPj1AFPg9vn1',
                             'rGFuMiw48HdbnrUbkRYuitXTmfrDBNTCnX',
                             'rDsbeomae4FXwgQTJp9Rs64Qg9vDiTCdBv',
                             'rvYAfWj5gh67oV6fW32ZzP3Aw4Eubs59B',
                             'rUobSiUpYH2S97Mgb4E7b7HuzQj2uzZ3aD'],
                'bitso':    ['rG6FZ31hDHN1K5Dkbma3PSB5uVCuVVRzfn',
                             'rHZaDC6tsGN2JWGeXhjKL6664RNCq5hu4B',
                             'raXLsnnJVaLMDixEoXHXe56WQXKczbD8ub',
                             'rGfGdVYLDSbji5mqfMvdpx4c8JyyfqVFgf',
                             'rfEu1Wnr7LxStoFx8DBdzgr8M16FBUbH3K',
                             'rLSn6Z3T8uCxbcd1oxwfGQN1Fdn5CyGujK']}


def getBitstamp(time):
    '''
    This function returns the history of XRPUSD transactions on Bitstamp
    using the HTTP v2 API.

    Args:
        time: the historical span, can be 1h or 24h,
              other options are not supported by the API.

    Returns:
        List of XRPUSD transactions.
    '''

    # call bitstamp API
    Bitstamp = bitstamp.client.Public()
    # the API only supports last hour our last 24 hours history
    qtime = bitstamp.client.TransRange.DAY if time == 24 else bitstamp.client.TransRange.HOUR
    txs = Bitstamp.transactions(base='xrp', quote='usd', time=qtime)

    # store the results in a list of dictionaries, transactions sorted by datetime
    res = [dict(type='buy' if tx['type'] == '0' else 'sell',
                amount=Decimal(tx['amount']),
                dt=datetime.fromtimestamp(Decimal(tx['date']), tzutc()),
                price=Decimal(tx['price'])) for tx in txs]

    # sort by datetime
    res.sort(key=lambda x: x['dt'])

    return res


def getBitso(time):
    '''
    This function returns the history of XRPMXN transactions on Bitso
    using the HTTP API.

    Args:
        time: the historical span in hours.

    Returns:
        List of XRPMXN transactions.
    '''

    Bitso = bitso.Api()

    # prepare for using the paging mechanism
    begin = datetime.now(timezone.utc) - timedelta(hours=time)

    # fetch first page
    txs = Bitso.trades('xrp_mxn', limit=100)
    res = [dict(amount=Decimal(tx.amount),
                type=tx.maker_side,
                dt=tx.created_at,
                price=Decimal(tx.price)) for tx in txs]

    # fetch next pages until we hit the targeted historical span
    while len(res) > 0 and txs[-1].created_at > begin:
        txs = Bitso.trades('xrp_mxn', limit=100, marker=txs[-1].tid)
        res.extend([dict(amount=Decimal(tx.amount),
                    type=tx.maker_side,
                    dt=tx.created_at,
                    price=Decimal(tx.price)) for tx in txs])

    # sort by datetime
    res.sort(key=lambda x: x['dt'])
    return res