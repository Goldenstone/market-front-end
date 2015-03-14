# -*- coding: utf-8 -*-
import json
from flask import Flask
from flask import render_template
from flask import make_response
app = Flask(__name__)
app.debug = True

user = {
    'location': u'中山大学至善园1号',
    'name': u'张三',
}
catx = []
for i in range(7):
    cat2s = []
    for j in range(4):
        cat2s.append({
            'name': u'二级分类' + str(i)
        })
    catx.append([{'name': u'一级分类' + str(i)}, cat2s])

hot_goods = []
for i in range(11):
    quantity = 5
    if i is 0:
        quantity = 0
    hot_goods.append([{
        'name': u'热销商品' + str(i),
        'price': 99,
        # if no pic_url then filename
        'pic_url': 'http://www.baidu.com/img/bdlogo.png'
    }, 999, quantity])

@app.route('/')
def main_page():
    banners = []
    for i in range(5):
        banners.append({
            'pic_url': 'http://www.baidu.com/img/bdlogo.png'
        })
    locations = []
    for i in range(5):
        buildings = []
        for j in range(10):
            buildings.append({
                'id': j,
                'name': 'building' + str(j)
            })
        locations.append([{
            'id': i,
            'name': 'school' + str(i)
        }, buildings])
    return render_template('main_page.html', user = user,\
        catx = catx, hot_goods = hot_goods,\
        locations = locations, banners = banners)

@app.route('/goods_list')
def goods_list_page():
    return render_template('goods_list_page.html', user = user,\
        catx = catx, goods_list = hot_goods)

@app.route('/shopping_cart')
def shopping_cart_page():
    return render_template('shopping_cart_page.html', user = user)

@app.route('/cart/goods', methods = ['POST'])
def get_cart_objs():
    cart_objs = []
    for i in range(6):
        flag = True
        if i is 0:
            flag = False
        cart_objs.append({
            'is_valid': flag,
            'quantity': 1,
            'product_id': i,
            'name': u'商品' + str(i),
            'filename': 'http://www.baidu.com/img/bdlogo.png',
            'price': 99
        })
    return make_response(json.dumps({'code': 0, 'data': cart_objs}))

if __name__ == '__main__':
    app.run()