# App Runner sorryサーバー 最小手順

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

```bash
mkdir sorry
cd sorry
echo '～～～' > index.html
# '～～～' はSorryHTMLファイルの中身

touch Dockerfile
vi Dockerfile
# 編集コマンドはvi以外でもよい
```

以下を Dockerfileに入力

```dockerfile
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

コマンドの続き

```bash
docker build -t xxxxxxx.dkr.ecr.ap-northeast-1.amazonaws.com/sorry:1 .
```

※「1」の後に半角スペースとドットがあるので忘れないこと

※「xxxxxxx」はアカウントIDを指定する

※コロンの後の 1 はバージョンを意味する

→　dockerイメージが完成する

```bash
docker images
```

→　作成したイメージがリストされることを確認

## ECRへDockerイメージのpush

Cloud9の画面の続きで作業

```bash
aws ecr create-repository --repository-name sorry

aws ecr get-login-password | docker login --username AWS --password-stdin xxxxxxx.dkr.ecr.ap-northeast-1.amazonaws.com
```

「xxxxxxx」はアカウントIDを指定する

AWS のところはそのまま「AWS」と入力でよい

→　Login Succeeded　と表示される

```bash
docker push xxxxxxx.dkr.ecr.ap-northeast-1.amazonaws.com/sorry:1
```

※「xxxxxxx」はアカウントIDを指定する

→　DockerイメージがECRにpush(送信)される

## App Runner サービス起動

- マネージメントコンソールでApp Runnerにアクセス
- 東京リージョンを選択
- サービスの作成ボタン
  - リポジトリタイプ: コンテナレジストリ
  - プロバイダー: Amazon ECR
  - コンテナイメージの URI: xxxxxxx.dkr.ecr.ap-northeast-1.amazonaws.com/sorry:1
  - デプロイトリガー: 手動
  - ECR アクセスロール: 新しいサービスロール
  - 次へボタン
  - サービス名: sorry-app
  - CPU: 0.25vCPU
  - メモリ: 0.5GB
  - ポート: 80
  - 次へボタン
  - 作成とデプロイボタン

→ サービスが作成される

作成後に表示されるURLに「/sorry」を付与してブラウザでアクセスすると、sorryページが表示される

## 後片づけ

- Cloud9の sorry 環境の削除
- App Runnerサービス削除
- ECRリポジトリ sorry の削除
