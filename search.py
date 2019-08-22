from datetime import timedelta


def getMatch(ex1, xrpl, ex2, tol_t=120, tol_a=0.05):
    '''
    This function searches for possible xRapid transactions.

    Args:
        ex1: List of exchange transactions on source exchange.
        xrpl: List of successful Payment transactions between the exchanges.
        ex2: List of exchange transaction on destination exchange.
        tol_t: Time tolerance (in seconds).
        tol_a: Amount tolerance (relative, e.g. 0.01 = 1%).

    Returns:
        List of triplets
    '''

    # this below is a rather clumsy algorithm, I'm sure I could do much better :-/
    # nevertheless, here it goes...
    res = []
    l1 = ex1.copy()
    l2 = xrpl.copy()
    l3 = ex2.copy()

    # iterate over all source XRP exchange events
    for t1 in l1:
        a1 = t1['amount']
        dt1 = t1['dt']

        # and all XRP payments
        for t2 in l2:
            a2 = t2['amount']
            dt2 = t2['dt']

            # if the payment is outside tolerance, skip
            if dt2 < dt1 or dt2 - dt1 > timedelta(seconds=tol_t) or abs(a2 - a1)/a1 > tol_a:
                continue

            # if the payment is within tolerance, iterate over destination XRP exchange events
            for t3 in l3:
                a3 = t3['amount']
                dt3 = t3['dt']

                # if the exchange is outside tolerance, skip
                if dt3 < dt2 or dt3 - dt2 > timedelta(seconds=tol_t) or abs(a3 - a2)/a2 > tol_a:
                    continue

                # if the exchange is within tolerance, we found a possible xRapid triple :-)
                res.append([t1, t2, t3])

                # remove the found payment and destination exchange event to prevent additional matches
                l2.remove(t2)
                l3.remove(t3)

                # break the inner-most loop, we found our triplet
                break

            # break the middle-loop, we found our triplet
            break

    return res


def Print(xRapid):
    '''
    Auxiliary function to print the results
    '''
    for t1, t2, t3 in xRapid:
        print('xRAPID transaction!')
        print(' 1.  Bitstamp\tUSDXRP    {:10.2f} XRP  {:8.0f} USD  at  {}'
              .format(t1['amount'], t1['amount']*t1['price'], t1['dt'].strftime('%Y-%m-%dT%H:%M:%S')))
        print(' 2.  ➝ XRPL ➝\t{}  {:10.2f} XRP                at  {}  (Δt = {}, ΔA = {:.2f})'
              .format(t2['dtag'], t2['amount'], t2['dt'].strftime('%Y-%m-%dT%H:%M:%S'),
                      (t2['dt'] - t1['dt']).total_seconds(), t2['amount'] - t1['amount']))
        print(' 3.  Bitso\tXRPMXN    {:10.2f} XRP  {:8.0f} MXN  at  {}  (Δt = {}, ΔA = {:.2f})'
              .format(t3['amount'], t3['amount']*t3['price'], t3['dt'].strftime('%Y-%m-%dT%H:%M:%S'),
                      (t3['dt'] - t2['dt']).total_seconds(), t3['amount'] - t2['amount']))
