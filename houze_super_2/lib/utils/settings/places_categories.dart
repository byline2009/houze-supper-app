import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryItem extends Equatable {
  final int id;
  final Widget icon;
  final String title;
  CategoryItem({
    required this.id,
    required this.icon,
    required this.title,
  });

  @override
  List<Object> get props => [
        id,
        icon,
        title,
      ];
}

class Voucher {
  static final List<CategoryItem> categories = [
    CategoryItem(
      id: -1,
      icon: SvgPicture.asset("assets/svg/icon/service/graphic-voucher.svg"),
      title: 'all',
    ),
    CategoryItem(
      id: 0,
      icon: SvgPicture.asset("assets/svg/icon/service/graphic-coffee-cup.svg"),
      title: 'coffee',
    ),
    CategoryItem(
      id: 1,
      icon: SvgPicture.asset("assets/svg/icon/service/graphic-food.svg"),
      title: 'food',
    ),
    CategoryItem(
      id: 2,
      icon: SvgPicture.asset("assets/svg/icon/service/graphic-clothes.svg"),
      title: 'fashion',
    ),
    CategoryItem(
      id: 3,
      icon: SvgPicture.asset("assets/svg/icon/service/graphic-heart.svg"),
      title: 'health_and_beauty',
    ),
    CategoryItem(
      id: 4,
      icon: SvgPicture.asset("assets/svg/icon/service/graphic-book.svg"),
      title: 'education',
    ),
    CategoryItem(
      id: 5,
      icon: SvgPicture.asset("assets/svg/icon/service/graphic-shop.svg"),
      title: 'others',
    ),
  ];
}

class PlacesAround {
  static final List<CategoryItem> categories = [
    CategoryItem(
      id: -1,
      icon: SvgPicture.asset("assets/svg/icon/service/destination.svg"),
      title: 'all',
    ),
    CategoryItem(
      id: 0,
      icon: SvgPicture.asset("assets/svg/icon/service/graphic-coffee-cup.svg"),
      title: 'coffee',
    ),
    CategoryItem(
      id: 1,
      icon: SvgPicture.asset("assets/svg/icon/service/graphic-food.svg"),
      title: 'food',
    ),
    CategoryItem(
      id: 2,
      icon: SvgPicture.asset("assets/svg/icon/service/graphic-clothes.svg"),
      title: 'fashion',
    ),
    CategoryItem(
      id: 3,
      icon: SvgPicture.asset("assets/svg/icon/service/graphic-heart.svg"),
      title: 'health_and_beauty',
    ),
    CategoryItem(
      id: 4,
      icon: SvgPicture.asset("assets/svg/icon/service/graphic-book.svg"),
      title: 'education',
    ),
    CategoryItem(
      id: 5,
      icon: SvgPicture.asset("assets/svg/icon/service/graphic-shop.svg"),
      title: 'others',
    ),
  ];
}
