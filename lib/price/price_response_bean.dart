/// Copyright  Shanghai eBest Information Technology Co. Ltd  2019
///  All rights reserved.
///
///  Author:       张国鹏
///  Email:        guopeng.zhang@ebestmobile.com)
///  Date:         2019-12-10 16:02

class PriceResponseBean {
    String contentEncoding;
    String contentType;
    Data data;
    int jsonRequestBehavior;
    String maxJsonLength;
    String recursionLimit;

    PriceResponseBean({this.contentEncoding, this.contentType, this.data, this.jsonRequestBehavior, this.maxJsonLength, this.recursionLimit});

    factory PriceResponseBean.fromJson(Map<String, dynamic> json) {
        return PriceResponseBean(
            contentEncoding: json['ContentEncoding'],
            contentType: json['ContentType'],
            data: json['Data'] != null ? Data.fromJson(json['Data']) : null,
            jsonRequestBehavior: json['JsonRequestBehavior'],
            maxJsonLength: json['MaxJsonLength'],
            recursionLimit: json['RecursionLimit'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['ContentEncoding'] = this.contentEncoding;
        data['ContentType'] = this.contentType;
        data['JsonRequestBehavior'] = this.jsonRequestBehavior;
        data['MaxJsonLength'] = this.maxJsonLength;
        data['RecursionLimit'] = this.recursionLimit;
        if (this.data != null) {
            data['data'] = this.data.toJson();
        }
        return data;
    }
}

class Data {
    double basePrice;
    double depositFee;
    double netPrice;
    double outputTax;
    List<Product> products;
    double subTotalOfDiscounts;

    Data({this.basePrice, this.depositFee, this.netPrice, this.outputTax, this.products, this.subTotalOfDiscounts});

    factory Data.fromJson(Map<String, dynamic> json) {
        return Data(
            basePrice: json['BasePrice'],
            depositFee: json['DepositFee'],
            netPrice: json['NetPrice'],
            outputTax: json['OutputTax'],
            products: json['Products'] != null ? (json['Products'] as List).map((i) => Product.fromJson(i)).toList() : null,
            subTotalOfDiscounts: json['SubTotalOfDiscounts'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['BasePrice'] = this.basePrice;
        data['DepositFee'] = this.depositFee;
        data['NetPrice'] = this.netPrice;
        data['OutputTax'] = this.outputTax;
        data['SubTotalOfDiscounts'] = this.subTotalOfDiscounts;
        if (this.products != null) {
            data['Products'] = this.products.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Product {
    double netPrice;
    String productRecordRef;
    List<SchemeRecord> schemeRecords;
    double subTotalFgTax;
    double subTotalOfDiscounts;
    double subTotalOfFgDiscounts;
    double tax;
    double totalBasePrice;

    Product({this.netPrice, this.productRecordRef, this.schemeRecords, this.subTotalFgTax, this.subTotalOfDiscounts, this.subTotalOfFgDiscounts, this.tax, this.totalBasePrice});

    factory Product.fromJson(Map<String, dynamic> json) {
        return Product(
            netPrice: json['NetPrice'],
            productRecordRef: json['ProductRecordRef'],
            schemeRecords: json['SchemeRecords'] != null ? (json['SchemeRecords'] as List).map((i) => SchemeRecord.fromJson(i)).toList() : null,
            subTotalFgTax: json['SubTotalFgTax'],
            subTotalOfDiscounts: json['SubTotalOfDiscounts'],
            subTotalOfFgDiscounts: json['SubTotalOfFgDiscounts'],
            tax: json['Tax'],
            totalBasePrice: json['TotalBasePrice'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['NetPrice'] = this.netPrice;
        data['ProductRecordRef'] = this.productRecordRef;
        data['SubTotalFgTax'] = this.subTotalFgTax;
        data['SubTotalOfDiscounts'] = this.subTotalOfDiscounts;
        data['SubTotalOfFgDiscounts'] = this.subTotalOfFgDiscounts;
        data['Tax'] = this.tax;
        data['TotalBasePrice'] = this.totalBasePrice;
        if (this.schemeRecords != null) {
            data['SchemeRecords'] = this.schemeRecords.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class SchemeRecord {
    double discountValue;
    double fgTotalValue;
    String freeGoodProductRef;
    double priceListNo;
    String schemeRecordRef;
    String stepTypeDescription;
    int stepTypeId;
    String stepTypeName;
    double tax;
    int type;
    String typeDescription;
    String unitOfMeasure;
    double unitPrice;
    double value;

    SchemeRecord({this.discountValue, this.fgTotalValue, this.freeGoodProductRef, this.priceListNo, this.schemeRecordRef, this.stepTypeDescription, this.stepTypeId, this.stepTypeName, this.tax, this.type, this.typeDescription, this.unitOfMeasure, this.unitPrice, this.value});

    factory SchemeRecord.fromJson(Map<String, dynamic> json) {
        return SchemeRecord(
            discountValue: json['DiscountValue'],
            fgTotalValue: json['FgTotalValue'],
            freeGoodProductRef: json['FreeGoodProductRef'],
            priceListNo: json['PriceListNo'],
            schemeRecordRef: json['SchemeRecordRef'],
            stepTypeDescription: json['StepTypeDescription'],
            stepTypeId: json['StepTypeId'],
            stepTypeName: json['StepTypeName'],
            tax: json['Tax'],
            type: json['Type'],
            typeDescription: json['TypeDescription'],
            unitOfMeasure: json['UnitOfMeasure'],
            unitPrice: json['UnitPrice'],
            value: json['Value'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['DiscountValue'] = this.discountValue;
        data['FgTotalValue'] = this.fgTotalValue;
        data['FreeGoodProductRef'] = this.freeGoodProductRef;
        data['PriceListNo'] = this.priceListNo;
        data['SchemeRecordRef'] = this.schemeRecordRef;
        data['StepTypeDescription'] = this.stepTypeDescription;
        data['StepTypeId'] = this.stepTypeId;
        data['StepTypeName'] = this.stepTypeName;
        data['Tax'] = this.tax;
        data['Type'] = this.type;
        data['TypeDescription'] = this.typeDescription;
        data['UnitOfMeasure'] = this.unitOfMeasure;
        data['UnitPrice'] = this.unitPrice;
        data['Value'] = this.value;
        return data;
    }
}