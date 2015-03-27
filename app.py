# -*- coding: utf-8 -*-
import json
from flask import Flask
from flask import render_template
from flask import make_response
from flask import request
app = Flask(__name__)
app.debug = True

user = {
    'location': u'中山大学至善园1号',
    'name': u'张三',
}
count = 0
catx = []
for i in range(8):
    cat2s = []
    for j in range(4):
        cat2s.append({
            'name': u'二级分类' + str(i),
            'id': j

        })
    catx.append([{'name': u'一级分类' + str(i), 'id': i}, cat2s])

hot_products = []
for i in range(10):
    quantity = 5
    if i is 0:
        quantity = 0
    hot_products.append([{
        'name': u'热销商品' + str(i),
        'price': 99,
        # if no pic_url then filename
        'filename': 'http://www.baidu.com/img/bdlogo.png'
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
        catx = catx, hot_products = hot_products,\
        locations = locations, banners = banners)

@app.route('/product/list')
def get_list():
    current_cart = {
        'name': u'一级分类1',
        'id': 1
    }
    return render_template('products_list_page.html', user = user, \
        catx = catx, products = hot_products, current_cat1= current_cart)

@app.route('/product/list', methods = ['POST'])
def post_list():
    # price =  request.form['cat1_id']
    price = 0
    st = price
    list_products = []
    for j in range(10):
        list_products.append({
            'id': j,
            'name': 'product' + str(st),
            'description': 'heheheheheh',
            'filename': 'http://www.baidu.com/img/bdlogo.png',
            'price': price,
            'quantity': 6,
            'sold_cnt': 10
        })
    current_cart = {
        'name': u'一级分类1',
        'id': price
    }
    products = {
        'products': list_products,
        # 'current_cat1': current_cart
    }
    return make_response(json.dumps({'code': 0, 'data': products}))

@app.route('/order')
def get_order():
    orders = {}
    return render_template('order_page.html', user = user,\
        orders = orders)

@app.route('/shopping_cart')
def shopping_cart():
    return render_template('shopping_cart_page.html', user = user)

@app.route('/order_list')
def order_list():
    orders = []
    for i in range(5):
        if i == 1:
            timedelta = 35555550
        else:
            timedelta = 36000000
        orders.append({
            'id': i, # 订单id，前端没有用到，还是提供咯
            'ticketid': u'i', # 订单编号
            'sender_name': u'和恒', # 送货人名称
            'sender_contact_info': u'13812312312', # 送货人联系方法，正常就手机号
            'price': 100, # 订单总价
            'released_time': 1427426384292, # 下单时间。
            'timedelta': timedelta, # 送货时间长度。前端需要用js根据这两个时间计算剩余时间的倒计时
            'timeout': True, # 是否已超时，是的话，要标记为超时状态。
            'password': u'1234', # 动态密码
            'status': u'uncompleted', # 订单状态，未完成/完成/关闭
            'items':
            [
                {
                    'id': 1, # 商品快照id
                    'filename': u'http://www.baidu.com/img/bdlogo.png', # 用于图片加载
                    'name': u'商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1商品1', # 商品名称
                    'description': u'好商品', # 商品描述
                    'price': 10.0, # 商品价格
                    'quantity': 5, # 购买数量
                },
                {
                    'id': 2, # 商品快照id
                    'filename': u'http://www.baidu.com/img/bdlogo.png', # 用于图片加载
                    'name': u'商品1', # 商品名称
                    'description': u'好商品', # 商品描述
                    'price': 10, # 商品价格
                    'quantity': 5, # 购买数量
                },
                {
                    'id': 3, # 商品快照id
                    'filename': u'http://www.baidu.com/img/bdlogo.png', # 用于图片加载
                    'name': u'商品1', # 商品名称
                    'description': u'好商品', # 商品描述
                    'price': 10, # 商品价格
                    'quantity': 5, # 购买数量
                }
            ]
        })
    return render_template('orders_list_page.html', user = user, orders = orders)

@app.route('/cart', methods = ['POST'])
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

@app.route('/user/choose_location', methods = ['POST'])
def get_chosen_location():
    token = {
        '_csrf_token': u'token'
    }
    return make_response(json.dumps({'code': 0, 'data': token}))

@app.route('/cart/cnt', methods = ['POST'])
def get_cart_cnt():
    return make_response(json.dumps({'code': 0, 'data': count}))

@app.route('/location/school_list')
def get_school_list():
    school_list = []
    for j in range(5):
        school_list.append({
            'id': j,
            'name': u'school' + str(j)
        })
    return make_response(json.dumps({'code': 0, 'data': school_list}))

@app.route('/location/<int:school_id>/building_list')
def get_building_list(school_id):
    building_list = []
    for j in range(10):
        building_list.append({
            'id': j,
            'name': str(school_id) + u'building' + str(j)
        })
    return make_response(json.dumps({'code': 0, 'data': building_list}))

@app.route('/cart/insert', methods = ['POST'])
def insert_cart():
    return make_response(json.dumps({'code': 0}))

@app.route('/user/contact_info', methods = ['POST'])
def get_contact_info():
    contact = {
        'name': u"张三",
        'phone': u"1350564335",
        'addr': u"中山大学明德园2号323中山大学明德园2号323中山大学明德园2号323中山大学明德园2号323中山大学明德园2号323"
    }
    return make_response(json.dumps({'code': 0, 'data': contact}))

if __name__ == '__main__':
    app.run()
