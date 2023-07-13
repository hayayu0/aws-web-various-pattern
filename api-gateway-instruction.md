# API Gateway sorryサーバー 最小手順

## API Gatewayの作成

- AWSマネージメントコンソールを開く
- 東京リージョンを選択
- API Gatewayにアクセス
- APIを作成ボタン
- REST APIの構築ボタン
  - プロトコル: REST
  - 新しいAPIの作成: Swagger あるいは Open API 3 からインポート
  - 入力ボックスにapi-gateway-swagger.json の内容を入力
  - エンドポイントタイプ: リージョン
  - 警告を失敗とみなすを選択
  - インポートボタンを押す
  
→　APIが作成される

## ステージの作成

- 左のツリーで「リソース」をクリック
- アクションのドロップダウンで、APIのデプロイを選択
  - デプロイされるステージ: 新しいステージ
  - ステージ名: sorry (本来は prod, dev 等だがURLの末尾に付くためここはsorryとする)
  - デプロイボタンを押す

→　ステージが作成される

→　URLの呼び出し の文字の後にURL「xxxx.execute-api.ap-northeast-1.amazonaws.com/sorry」が表示される

表示されたURLにアクセスするとsorryページが表示される


## 後片付け

- アクション ＞ APIの削除
