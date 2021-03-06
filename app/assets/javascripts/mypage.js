$(document).on('turbolinks:load', function() {
  // パスの取得
  const pathName = location.pathname;

  // マイページのパスの時
  $(function() {
    if (pathName.includes("/users/mypage")) {
      $("ul.mypage-nav__list li:eq(0) .arrow-right").css("color", "black");
      $("ul.mypage-nav__list li:eq(0)").css("background-color", "rgb(238, 238, 238)");
    
  // いいね！一覧のパスの時
    } else if (pathName == ("/likes")) {
      $("ul.mypage-nav__list li:eq(3)").css("background-color", "rgb(238, 238, 238)");
      $("ul.mypage-nav__list li:eq(3) .arrow-right").css("color", "black");

  // 出品した商品-出品中のパスの時
    } else if (pathName.includes("/users/listing")) {
      $("ul.mypage-nav__list li:eq(5)").css("background-color", "rgb(238, 238, 238)");
      $("ul.mypage-nav__list li:eq(5) .arrow-right").css("color", "black");

  // 出品した商品-取引中のパスの時
    } else if (pathName.includes("/users/in_progress")) {
      $("ul.mypage-nav__list li:eq(6)").css("background-color", "rgb(238, 238, 238)");
      $("ul.mypage-nav__list li:eq(6) .arrow-right").css("color", "black");

  // 出品した商品-売却済みのパスの時
    } else if (pathName.includes("/users/completed")) {
      $("ul.mypage-nav__list li:eq(7)").css("background-color", "rgb(238, 238, 238)");
      $("ul.mypage-nav__list li:eq(7) .arrow-right").css("color", "black");

  // 購入した商品-取引中のパスの時
    } else if (pathName.includes("/users/purchase")) {
      $("ul.mypage-nav__list li:eq(8)").css("background-color", "rgb(238, 238, 238)");
      $("ul.mypage-nav__list li:eq(8) .arrow-right").css("color", "black");

  // 購入した商品-過去の取引のパスの時
    } else if (pathName.includes("/users/purchased")) {
      $("ul.mypage-nav__list li:eq(9)").css("background-color", "rgb(238, 238, 238)");
      $("ul.mypage-nav__list li:eq(9) .arrow-right").css("color", "black");

  // プロフィールのパスの時
    } else if (pathName.includes("/users/profile")) {
      $("ul.side-menu__config-ul li:eq(0)").css("background-color", "rgb(238, 238, 238)");
      $("ul.side-menu__config-ul li:eq(0) .arrow-right").css("color", "black");

  // 本人情報のパスの時
    } else if (pathName.includes("/users/identification")) {
      $("ul.side-menu__config-ul li:eq(4)").css("background-color", "rgb(238, 238, 238)");
      $("ul.side-menu__config-ul li:eq(4) .arrow-right").css("color", "black");

  // ログアウトのパスの時
    } else if (pathName.includes("/users/logout")) {
      $("ul.side-menu__config-ul li:eq(6)").css("background-color", "rgb(238, 238, 238)");
      $("ul.side-menu__config-ul li:eq(6) .arrow-right").css("color", "black");
    }
  });

});