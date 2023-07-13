# ECS sorryサーバー 最小手順

## Dockerイメージ作成

- マネージメントコンソールでCloud9にアクセス
- 環境を作成
  - 名前: sorry
  - 環境タイプ: 新しいEC2インスタンス
  - インスタンスタイプ: t2.micro
  - 作成ボタン

- 数分待ってから作成したsorry環境を開く

- 開いたCloud9環境の下側のウインドウにカーソルを合わせる

- 以下のコマンドを入力

mkdir sorry

cd sorry

echo '～～～' > index.html

※'～～～' はSorryHTMLファイルの中身

touch Dockerfile

vi Dockerfile (※編集コマンドはvi以外でもよい) 

以下を Dockerfileに入力

```
FROM ubuntu:18.04
RUN apt-get update && apt-get -y install apache2
RUN mkdir -p /var/www/html/sorry
ADD ./index.html /var/www/html/sorry/index.html
RUN echo '. /etc/apache2/envvars' > /root/run-apache.sh && \
 echo 'mkdir -p /var/run/apache2' >> /root/run-apache.sh && \
 echo 'mkdir -p /var/lock/apache2' >> /root/run-apache.sh && \ 
 echo '/usr/sbin/apache2 -D FOREGROUND' >> /root/run-apache.sh && \ 
 chmod a+x /root/run-apache.sh
EXPOSE 80
CMD /root/run-apache.sh
```

docker build -t xxxxxxx.dkr.ecr.ap-northeast-1.amazonaws.com/sorry:1 .

※1 の後に半角スペースとドットがあるので忘れないこと

※-t に指定するものは、上記でメモしておいた文字の後に 「:1」を付与した文字。
ちなみにコロンの後の 1 はバージョンを意味する

→　dockerイメージが完成する

docker images

→　作成したイメージがリストされることを確認

## ECRへDockerイメージのpush

Cloud9の画面の続きで作業

aws ecr create-repository --repository-name sorry

aws ecr get-login-password | docker login --username AWS --password-stdin ～～.com

※～～.com　は メモしておいた文字から /sorry を除いたもの

※AWS のところはそのまま「AWS」と入力でよい

→　Login Succeeded　と表示される

docker push ～～.com/sorry:1

※～～.com/sorry:1 は、メモしておいた文字の後に 「:1」を付与した文字

→　DockerイメージがECRにpush(送信)される

## ECS クラスター定義

- マネージメントコンソールでElastic Container Service (ECS) にアクセス
- 東京リージョンを選択
- クラスターの作成ボタン
    - クラスター名: sorry
    - サブネット: ap-northeast-1a の1つだけに減らす
    - 作成ボタン

→ CloudFormationでクラスターが作成される

## ECS タスク定義

- 左でタスク定義をクリック
- 新しいタスク定義の作成をクリック
    - タスク定義ファミリー: sorry
    - コンテナの詳細－名前: sorry
    - コンテナの詳細－URI: ～～.com/sorry:1
    - 次へボタン
    - アプリケーション環境: AWS Fargate
    - オペレーティングシステム/アーキテクチャ: Linux/X86_64
    - CPU 0.5 vCPU
    - メモリ 1 GB
    - ログ収集の使用: チェックを外す
    - 次へボタン
    - 作成ボタン

→ タスクが作成される

## ECS サービス作成

- 左でクラスターを選択
- sorry クラスターを選択
- サービスタブをクリック
- 作成ボタンを押す
    - コンピューティングオプション: 起動タイプ
	- 起動タイプ: FARGATE
    - デプロイ設定: サービス
    - タスク定義ファミリー: sorry
    - サービス名: sorrysvc
    - 必要なタスク: 1
    - 作成ボタン

→ CloudFormationでサービスが作成される

→ タスクの設定でパブリックIPに表示されるIPアドレスを記録しておく

## セキュリティグループの設定

- 左でクラスターを選択
- sorry クラスターを選択
- サービスタブをクリック
- sorrysvcをクリック
- ネットワーキングタブをクリック
- セキュリティグループに表示されている sg-xxxxxxxx をクリック
- インバウンドルールの編集ボタン
- ルールを追加ボタン
    - タイプ: HTTP
    - プロトコル: TCP(自動入力)
    - ポート範囲: 80(自動入力)
    - ソース: 0.0.0.0/0
    - ルールを保存ボタン

→　インターネットからポート80へのアクセスが開かれる

タスクの設定でメモしておいたパブリックIPを使って xx.xx.xx.xx/sorry/ にブラウザでアクセスすると、
sorryページが表示される


## 後片づけ

- ECSタスクの登録削除
- ECSクラスター内のサービス sorrysvc の強制削除
- ECSクラスター sorry の削除
- ECRリポジトリ sorry-html の削除
- AWS Cloud Map 名前空間 sorry の削除
ECSクラスター sorry の削除
- Cloud9の sorry 環境の削除
