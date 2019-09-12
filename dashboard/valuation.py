#!/usr/bin/python3

from cryptowatch_client import Client
import pandas as pd
import numpy as np

client = Client(timeout=30)

# get data from cryptowat.ch
granularity=14400 # seconds
res = client.get_markets_ohlc(exchange='bitstamp', pair='xrpusd', after=1429747200, periods=granularity)
olhc = res.json()['result'][str(granularity)]

# calculate simple average of OLHC
avg = pd.DataFrame([[ts, 0.25*(o + l + h + c)] for ts,o,l,h,c,_,_ in olhc], columns = ['TimeStamp', 'Price'])

# load inter-exchange XRPL data
data = pd.read_csv('InterExchange.csv')

# interpolate
data['Price'] = data.apply(lambda x: np.interp(x.Timestamp + 946684800, avg.TimeStamp, avg.Price), axis=1)
data['AmountUSD'] = data.Amount * data.Price

# save results
data.to_csv('InterExchangeUSD.csv', index=False)
