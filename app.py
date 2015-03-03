# -*- coding: utf-8 -*-
from flask import Flask
from flask import render_template
app = Flask(__name__)
app.debug = True

@app.route('/')
def main_page():
    user = {
        'is_login': True,
        'name': 'user0',
        'location': 'sysu zhishanyuan 2',
        'shopping_cart_amount': 10
    }
    kinds = ['kind1', 'kind2', 'kind3']
    hot_goods = [
        'hot good 1',
        'hot good 2',
        'hot good 3',
        'hot good 4',
        'hot good 5',
        'hot good 6',
    ]
    return render_template('main_page.html', user = user,\
        kinds = kinds, hot_goods = hot_goods)

@app.route('/goods_list')
def goods_list_page():
    return render_template('goods_list_page.html')

@app.route('/shopping_cart')
def shopping_cart_page():
    return render_template('shopping_cart_page.html')

if __name__ == '__main__':
    app.run()