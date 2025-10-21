import '../../../../core/utils/Utils.dart';
import '../../../../shared/models/translations.dart';

class StaticPageModel {
  int lastPage = 1;
  List<StaticPage>? staticPages;

  //from json
  StaticPageModel.fromJson(Map<String, dynamic> json) {
    lastPage = json['meta'] != null ? json['meta']['last_page'] : 1;
    staticPages = json['data'] != null
        ? List<StaticPage>.from(json['data'].map((x) => StaticPage.fromJson(x)))
        : null;
  }
}

class StaticPage {
  int? id;
  TranslationModel? translation;
  String? nameApi;
  String? phone;
  String? taxNumber;
  String? address;

  StaticPage(
      {this.id,
      this.nameApi,
      this.phone,
      this.taxNumber,
      this.address,
      this.translation});
  String get name {
    return Utils.local == "ar"
        ? translation?.ar ?? nameApi ?? ""
        : translation?.en ?? nameApi ?? "";
  }

  StaticPage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameApi = json['name'];
    translation = json['name_json'] != null
        ? TranslationModel.fromJson(json['name_json'])
        : null;
    phone = json['phone'];
    taxNumber = json['tax_number'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = {
      "en": translation?.en,
      "ar": translation?.ar,
    };
    data['phone'] = phone;
    data['tax_number'] = taxNumber;
    data['address'] = address;
    return data;
  }

  @override
  String toString() {
    return name ?? "";
  }
}
