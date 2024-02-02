// class FaqController {
//
//   getFaqApi({required String userId}) async {
//
//     await ApiHelper.get(
//       api: UrlConst.getFaqUrl,
//       body: {
//       },
//       onSuccess: ({required response}) {
//         loading(false);
//         log(response.body);
//         Map<String, dynamic> obj = jsonDecode(response.body);
//         log(obj.toString());
//         if (obj['status'] == "1") {
//           faqList.clear();
//           //showToast(title:"Success",message: obj['message']);
//           faqList(FaqModel.fromJson(obj).data);
//         }
//         else {
//           faqList.clear();
//           // showToast(title:"Failed",message: obj['message']);
//         }
//       },
//       onFailure: ({required message}) {
//         loading(false);
//         showToast(title:"Error",message: message);
//
//       },
//     );
//   }
// }