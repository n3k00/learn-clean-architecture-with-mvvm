import 'dart:async';

import 'package:complete_advanced_flutter/domain/model/model.dart';
import 'package:complete_advanced_flutter/presentation/base/base_view_model.dart';
import 'package:complete_advanced_flutter/presentation/resources/assets_manager.dart';
import 'package:complete_advanced_flutter/presentation/resources/strings_manager.dart';

class OnBoardingViewModel extends BaseViewModel
    implements OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  final StreamController streamController =
      StreamController<SliderViewObject>();
  late final List<SliderObject> _list;
  int currentIndex = 0;

  @override
  void dispose() {
    streamController.close();
  }

  @override
  void start() {
    // TODO: implement start
    _list = getSliderData();
    _postDataToView();
  }

  @override
  int goNext() {
    int previousIndex = currentIndex++; // -1
    if (previousIndex >= _list.length) {
      currentIndex =
          _list.length - 1; // infinite loop to go to the length of slider list
    }
    return currentIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = currentIndex--; // -1
    if (previousIndex == -1) {
      currentIndex =
          _list.length - 1; // infinite loop to go to the length of slider list
    }
    return currentIndex;
  }

  @override
  void onPageChanged(int index) {
    currentIndex = index;
    _postDataToView();
  }

  @override
  // TODO: implement inputSliderViewObject
  Sink get inputSliderViewObject => streamController.sink;

  @override
  // TODO: implement outputSliderViewObject
  Stream<SliderViewObject> get outputSliderViewObject =>
      streamController.stream.map((sliderViewObject) => sliderViewObject);

  List<SliderObject> getSliderData() => [
        SliderObject(
          AppString.onBoardingTitle1,
          AppString.onBoardingSubTitle1,
          ImageAssets.onboardingLogo1,
        ),
        SliderObject(
          AppString.onBoardingTitle2,
          AppString.onBoardingSubTitle2,
          ImageAssets.onboardingLogo2,
        ),
        SliderObject(
          AppString.onBoardingTitle3,
          AppString.onBoardingSubTitle3,
          ImageAssets.onboardingLogo3,
        ),
        SliderObject(
          AppString.onBoardingTitle4,
          AppString.onBoardingSubTitle4,
          ImageAssets.onboardingLogo4,
        ),
      ];
  _postDataToView() {
    inputSliderViewObject.add(SliderViewObject(
      _list[currentIndex],
      _list.length,
      currentIndex,
    ));
  }
}

abstract class OnBoardingViewModelInputs {
  void goNext();
  void goPrevious();
  void onPageChanged(int index);
  Sink get inputSliderViewObject;
}

abstract class OnBoardingViewModelOutputs {
  Stream<SliderViewObject> get outputSliderViewObject;
}

class SliderViewObject {
  SliderObject sliderObject;
  int numberOfSlide;
  int currentIndex;
  SliderViewObject(this.sliderObject, this.numberOfSlide, this.currentIndex);
}
