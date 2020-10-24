import 'package:cloud_firestore/cloud_firestore.dart';

class CollectionService {
  CollectionService(String collectioName) {
    this.collectionName = collectioName;
  }

  final Firestore database = Firestore.instance;
  String collectionName;

  Stream getCollectionOrderby(order) {
    return database.collection(this.collectionName).orderBy(order).snapshots();
  }
  Stream getCollectionOrderbyWhere(order,field) {
    return database.collection(this.collectionName).orderBy(order).where(field,isEqualTo: true).snapshots();
  }
  Stream getCollection() {
    return database.collection(this.collectionName).snapshots();
  }

  getDocById(id) {
    return database.collection(this.collectionName).document(id).get();
  }
  Stream getDocWithFilter(id) {
    return database.collection(this.collectionName).where("customer_data.mobile_no",isEqualTo: id).snapshots();
  }

  createDoc(doc) {
    this
        .database
        .collection(this.collectionName)
        .document()
        .setData(doc)
        .catchError((onError) {
      print(onError);
    });
  }

  createDocWithId(doc, id) {
    this
        .database
        .collection(this.collectionName)
        .document(id)
        .setData(doc)
        .catchError((onError) {
      print(onError);
    });
  }

  updateDoc(id, doc) {
    this
        .database
        .collection(this.collectionName)
        .document(id)
        .updateData(doc)
        .catchError((onError) {
      print(onError);
    });
  }

  deleteDoc(id) {
    this
        .database
        .collection(this.collectionName)
        .document(id)
        .delete()
        .catchError((onError) {
      print(onError);
    });
  }

  Stream getProductByCategory(String category) {
    return database
        .collection(this.collectionName)
        .where('category', isEqualTo: category)
        .snapshots();
  }
}
