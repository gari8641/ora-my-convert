<?php

define('DB_HOST', '192.168.1.2');
define('DB_USER', 'hoge');
define('DB_PASSWORD', 'hoge');
define('DB_NAME', 'fuga');

// DBへ接続
$link = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
if(!$link){
    die("データベースの接続に失敗しました");
}

// 文字化け防止
mysqli_set_charset($link, "utf8");


// 対象テーブルごとにcsvファイル作ってデータ書き込む
csv_kakikomi('table1');
csv_kakikomi('table2');
csv_kakikomi('table3');



// 接続を閉じる
mysqli_close($link);


function csv_kakikomi($table_name) {

    echo "$table_name はじまり\n";
    global $link;


    // クエリの実行
    $sql = "SELECT * FROM $table_name";

    // SELECT文の発行
    $sql_result = mysqli_query($link, $sql);
    if (!$sql_result) {
        die("クエリーが失敗" . mysqli_error());
    }


    // ファイル削除
    file_delete("${table_name}.csv");

    // データの取得及び取得データの表示
    while ($row = mysqli_fetch_assoc($sql_result)) 
    {
        $values = array_values($row);
        foreach($values as $key => $value)
        {
            // NULLなら、"NULL"ていう文字列にしちゃう
            if(is_null($value)) $value = "NULL";

            // 行の中で最後だったら「,」つけない。
            if ($key !== array_key_last($values)) $value = "{$value},";

            // tsuiki($table_name, "{$value},");
            tsuiki($table_name, $value);
        }
        tsuiki($table_name, "\n");
    }
    echo "$table_name おわり\n";
}


// csvファイルに追記
function tsuiki($table_name, $mojiretu)
{
    file_put_contents("{$table_name}.csv", $mojiretu, FILE_APPEND);
}


// ファイル削除
function file_delete($csv_file){
    if (file_exists($csv_file))
    {
        $del_result = unlink($csv_file);
        if( $del_result ) {
            echo "最初に{$csv_file}ファイルを削除しました。\n";
        } else {
            echo "{$csv_file}ファイルの削除に失敗しました。\n";
        }
    }
}
