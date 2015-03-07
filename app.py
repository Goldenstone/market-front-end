# -*- coding: utf-8 -*-
from flask import Flask
from flask import render_template
app = Flask(__name__)
app.debug = True

user = {
    'location': u'中山大学至善园1号',
    'name': u'张三',
    'cart_quantity': 9
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
    goods_list = []
    for i in range(6):
        goods_list.append({
            'is_null': False,
            'pic_url': 'http://www.baidu.com/img/bdlogo.png',
            'name': u'商品' + str(i),
            'price': 99,
            'quantity': 1
        })
    return render_template('shopping_cart_page.html', user = user,\
        goods_list = goods_list)

# api
@app.route('/location/school_list')
def school_list_handler():
    school_list = []
    for i in range(5):
        school_list.append({
            'id': i,
            'name': u'大学' + str(i)
        })

if __name__ == '__main__':
    app.run()