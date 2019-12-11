/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019-12-10 15:45

class PriceRequestBean {
    String bottlersCode;
    String calcDate;
    String customerRef;
    List<Product> products;
    String token;

    PriceRequestBean({this.bottlersCode, this.calcDate, this.customerRef, this.products, this.token});

    factory PriceRequestBean.fromJson(Map<String, dynamic> json) {
        return PriceRequestBean(
            bottlersCode: json['BottlersCode'],
            calcDate: json['CalcDate'],
            customerRef: json['CustomerRef'],
            products: json['products'] != null ? (json['products'] as List).map((i) => Product.fromJson(i)).toList() : null,
            token: json['Token'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['BottlersCode'] = this.bottlersCode;
        data['CalcDate'] = this.calcDate;
        data['CustomerRef'] = this.customerRef;
        data['Token'] = this.token;
        if (this.products != null) {
            data['products'] = this.products.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Product {
    String productRef;
    int quantity;
    String unitOfMeasure;

    Product({this.productRef, this.quantity, this.unitOfMeasure});

    factory Product.fromJson(Map<String, dynamic> json) {
        return Product(
            productRef: json['ProductRef'],
            quantity: json['Quantity'],
            unitOfMeasure: json['UnitOfMeasure'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['ProductRef'] = this.productRef;
        data['Quantity'] = this.quantity;
        data['UnitOfMeasure'] = this.unitOfMeasure;
        return data;
    }
}