# Elastic Beanstalk sorryサーバー 最小手順

## パッケージ作成

- 3ファイルを作成

package.json

```json
{
  "name": "Elastic-Beanstalk-Sorry",
  "version": "1.0",
  "dependencies": {},
  "scripts": { "start": "node app.js" }
}
```

app.js

```js
const http = require('http');
const fs = require('fs');
const server = http.createServer(function (req, res) {
    res.writeHead(503);
    res.write(fs.readFileSync('sorry-html'));
    res.end();
});
server.listen(3000);
```

sorry-html

```html
<!DOCTYPE html>
<html>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>メンテナンス中 | サンプル株式会社</title>
<style>
  body{
    background: #eee;
  }
  h1{
    font-size: 1.5rem;
  }
</style>
<body>
    <img src="data:image/png;base64,iVBO・・中略・・" alt="サンプル株式会社ロゴ">
    <hr>
      <h1>ただいまメンテナンス中です(Elastic Beanstalk版)</h1>
    <hr>
    <p>
      ただいまサービスを停止しています。<br>
      ユーザーの皆様にはご不便をおかけしますが、今しばらくお待ち下さい。<br>
    </p>
</body>
</html>
```

- 3ファイルを圧縮して beanstalk-nodejs.zip にする

## IAMポリシーの作成

- AWSマネージメントコンソールを開く
- IAMにアクセス
- IAMポリシー ＞ ポリシーの作成ボタン

JSONでIAMポリシーを入力

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "BucketAccess",
            "Action": [
                "s3:Get*",
                "s3:List*",
                "s3:PutObject"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::elasticbeanstalk-*",
                "arn:aws:s3:::elasticbeanstalk-*/*"
            ]
        },
        {
            "Sid": "ElasticBeanstalkHealthAccess",
            "Action": [
                "elasticbeanstalk:PutInstanceStatistics"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:elasticbeanstalk:*:*:application/*",
                "arn:aws:elasticbeanstalk:*:*:environment/*"
            ]
        }
    ]
}
```

- IAMポリシー名: Beanstalk-sorry

## IAMロールの作成

- AWSマネージメントコンソールを開く
- IAMにアクセス
- IAMロール ＞ ロールの作成ボタン

  - ユースケース: EC2
  - 許可ポリシー: Beanstalk-sorry
  - IAMロール名: beanstalk-sorry

## セキュリティグループの作成

- AWSマネージメントコンソールを開く
- VPCにアクセス
- セキュリティグループの作成
  
  - セキュリティグループ名: http3000
  - セキュリティグループの説明: http3000
  - インバウンドルール
    - 種類: カスタムTCP
    - ポート範囲: 3000
    - ソース: 0.0.0.0/0
  - アウトバウンドルール
    - 無し（デフォルト設定を削除）

## Elastic Beanstalk アプリケーションを作成

- AWSマネージメントコンソールを開く
- 東京リージョンを選択
- Elastic Beanstalkにアクセス
- 環境を作成 ボタン
  - 環境枠: ウェブサーバー環境
  - アプリケーション名: sorrywebapp
  - 環境名: Sorrywebapp-env (自動入力される)
  - プラットフォーム: Node.js
  - アプリケーションコード: コードをアップロード
    - バージョンラベル: 1
    - ローカルファイル: beanstalk-nodejs.zip（先ほどのZIP）
  - プリセット: 単一インスタンス (無料利用枠の対象)
  - 次へボタン
  - サービスロール: 新しいサービスロールを作成して使用
  - サービスロール名: (自動で入力される)
  - EC2インスタンスプロファイル: beanstalk-sorry（先ほど作成したIAMロール）
  - 次へボタン
  - VPC: デフォルトVPC
  - パブリックIP　アクティブの状態: チェックON
  - インスタンスサブネット: ap-northeast-1a
  - 次へボタン
  - セキュリティグループ: http3000（作成したもの）
  - インスタンスタイプ: t2.micro
  - ヘルスレポート: ベーシック
  - マネージド更新 アクティブ状態: チェックOFF
  - 次へボタン
- 送信ボタンを押す

CloudFormationが自動的に実行され、設定が正しいにも関わらず途中で失敗することもある。その場合はエラーメッセージにリトライするよう指示があるので、リトライする。

DNS名はアプリケーション sorrywebapp 内から確認する。DNS名の .comの後に「:3000/」を付与したURLでWebブラウザからアクセスすると sorryページが表示される

## 後片づけ

- Elastic Beanstalk アプリケーション sorrywebappの削除
- セキュリティグループ http3000 の削除
- IAMロール beanstalk-sorry の削除
- IAMポリシー Beanstalk-sorry の削除
