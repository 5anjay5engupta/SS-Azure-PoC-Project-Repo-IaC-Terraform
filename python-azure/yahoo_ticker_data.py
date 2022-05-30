from yahoo_fin import stock_info as si

tl = ['aapl', 'amd', 'amzn', 'cmg', 'fb', 'googl', 'msft', 'nvda', 'shop', 'snap']
for t in tl:
    d = si.get_live_price(t)
    tu = '{ ' + t + ' : ' + str(round(d, 2)) + ' }'
    print(tu.upper())
