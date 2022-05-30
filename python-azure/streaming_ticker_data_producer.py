import time
from yahoo_fin import stock_info as si

tl = ['aapl', 'amd', 'amzn', 'cmg', 'fb', 'googl', 'msft', 'nvda', 'shop', 'snap']

while True:
    for t in tl:
        d = si.get_live_price(t)
        tp = '{ ' + t + ' : ' + str(round(d, 2)) + ' }'
        print(tp.upper())
    time.sleep(5)