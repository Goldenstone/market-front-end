# -*- coding: utf-8 -*-
from flask import Flask
from flask import render_template
app = Flask(__name__)
app.debug = True

@app.route('/')
def main_page():
    return render_template('main_page.html')

@app.route('/goods_list')
def goods_list_page():
    return render_template('goods_list_page.html')

@app.route('/shopping_cart')
def shopping_cart_page():
    return render_template('shopping_cart_page.html')

if __name__ == '__main__':
    app.run()