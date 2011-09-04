// Firefox user.js

//IPv6形式でDNS解決を行わない
user_pref("network.dns.disableIPv6", true);

user_pref("network.http.pipelining", true);

// ページ表示
//
//blink を無効化する
user_pref("browser.blink_allowed", false);
//marquee を無効化する
user_pref("browser.display.enable_marquee", false);
//GIFアニメのアニメーションを停止する
user_pref("image.animation_mode", "none");
//右クリックを禁止にさせない
user_pref("nglayout.events.dispatchLeftClickOnly", true);
//フレームをいつでもリサイズできる
user_pref("layout.frames.force_resizability", true);

// スペルチェックを無効にする
user_pref("layout.spellcheckDefault", 0);
// スペルチェックを有効にする
//user_pref("layout.spellcheckDefault", 1);

// フォーカス
//
//フォーカスした文字列に色をつける
//user_pref("browser.display.use_focus_colors", true);
//フォーカスした文字列に色をつけない
user_pref("browser.display.use_focus_colors", false);
//フォーカスした文字列の背景色
//user_pref("browser.display.focus_background_color", "#e5ffff");
//フォーカスした文字列の色
//user_pref("browser.display.focus_text_color", "#000000");

//画像を縮小して表示しない
//user_pref("browser.enable_automatic_image_resizing", false);

// ブラウザUI
//
// すべてのタブにクローズボタンを表示する
//user_pref("browser.tabs.closeButtons", 1);
// タブバーの右端にクローズボタンを表示する
user_pref("browser.tabs.closeButtons", 3);

// 最後のタブを閉じてもブラウザを終了しない
user_pref("browser.tabs.closeWindowWithLastTab", false);

// タブブラウジング
//
//target="_blank"を無効にする
// 1: 同じタブで開く
// 3: 新しいタブで開く
user_pref("browser.link.open_newwindow", 1);

// true : 新しいタブを現在のタブのすぐ右隣に追加する
// false : 新しいタブを全てのタブの末尾に追加する
user_pref("browser.tabs.insertRelatedAfterCurrent", false);

// ソース表示
//
//ソースの表示で長い行を自動的に折り返す
user_pref("view_source.wrap_long_lines", true);

// マウス
//
//ホイールスクロール量の設定
user_pref("mousewheel.withnokey.sysnumlines", false);
user_pref("mousewheel.withnokey.numlines", 8);

//タブ上で中クリックするとタブを閉じる
user_pref("middlemouse.contentLoadURL", false);

// 拡張機能
//
//NoScript
//バージョンアップ完了後、NoScriptページを表示しない
//user_pref("noscript.firstRunRedirection", false);

