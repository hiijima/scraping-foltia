# scraping-foltia

## 概要
foltia anime lockerサーバーの新番組表をスクレイピングして、メール通知します。

## Requirements
* docker
* docker-compose
* メールサーバーが存在すること(自身のGmailにリレー可能なメールサーバーなど)

## 環境変数の設定
`docker-compose.yml`の次の項目を修正すること

|項目|値|
|---|---|
|extra_hosts -> foltiaserver|foltiaが稼働してるサーバー|
|environment -> FROM_MAIL|メールの送信元|
|environment -> TO_MAIL|メールの送信先|
|environment -> MAIL_SERVER|メールサーバ|

## dockerイメージ作成
```:bash
docker build -t scraping-foltia:latest ./
```

## 実行
```:bash
docker-compose up
```

## 備考
foltia 4.5.8で確認済み
