# -*- coding: utf-8 -*-
from flask import Flask
from flask import render_template
app = Flask(__name__)
app.debug = True

@app.route('/')
def main_page():
    user = {
        location: u'中山大学至善园1号',
        name: u'张三',
        cart_quantity: 9
    }
    cat1s = []
    for i in range(7):
        cat2s = []
        for j in range(4):
            cat2s.append({
                name: u'二级分类' + str(i)
            })
        cat1s.append({
            name: u'一级分类' + str(i),
            cat2s:cat2s 
        })
    hot_goods = []
    for i in range(11):
        hot_goods.append({
            name: u'热销商品' + str(i),
            price: 99,
            # if no pic_url then filename
            pic_url: 'http://www.baidu.com/img/bdlogo.png'
        })
    banners = []
    for i in range(5):
        banners.append({
            pic_url: 'http://www.baidu.com/img/bdlogo.png'
        })
    return render_template('main_page.html')

@app.route('/goods_list')
def goods_list_page():
    return render_template('goods_list_page.html')

@app.route('/shopping_cart')
def shopping_cart_page():
    return render_template('shopping_cart_page.html')

if __name__ == '__main__':
    app.run()