import 'package:auto_forward_sms/core/enum/view_state.dart';
import 'package:flutter/cupertino.dart';

class BaseModel with ChangeNotifier {
  ViewState _state = ViewState.idle;
  // APIRepository _apiRepository = locator<APIRepository>();
  //
  // APIRepository get apiRepository => _apiRepository;
  //
  // set apiRepository(APIRepository value) {
  //   _apiRepository = value;
  //   notifyListeners();
  // }

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  updateUI() {
    notifyListeners();
  }
}
