# aws-web-various-pattern

## ここに置いてあるものは何か

AWS環境において、簡易的なWebサーバーを立てる場合に、どのようなパターンがあるのかを考えた時に、以下のサービスが思いつきます。

- EC2
- ECS
- Lightsail
- Elastic Beanstalk
- S3
- Lambda
- ELB
- API Gateway

これがベストプラクティスというわけではなく、他にも方法があると思いますし、
ここに挙げたけれども、ちょっとトリッキーかなという方法も含まれていたりします。

これらの設定に関係するスニペットや設定などを置いています。

Windows環境で作成しましたが、全てUTF-8、改行コードはLFとしています。

## EC2

以下の1ファイルが対象です。

- userdata.txt

手順のファイルはありません。  
EC2のユーザーデータを使ってEC2を起動(ローンチ)します。

## ECS

以下の2ファイルが対象です。

- Dockerfile
- ecs-instruction.md

手順のファイルは ecs-instruction.md です。  

## Lightsail

以下の1ファイルが対象です。

- lightsail.sh

手順のファイルはありません。  
Linux+nginxでインスタンスを起動(ローンチ)して、その後コンソールに lightsail.sh の内容をコピーペーストします。

## Elastic Beanstalk

以下の2ファイルが対象です。

- beanstalk-nodejs.zip (ZIP内: package.json, 404, sorry, app.js)
- beanstalk-instruction.md

手順のファイルは beanstalk-instruction.md です。  

## S3

以下の2ファイルが対象です。

- sorry.html
- s3-bucketpolicy.txt

手順のファイルはありません。  
S3バケットにs3-bucketpolicy.txtのバケットポリシーを入力して、sorry.html をアップロードします。

## Lambda

以下の1ファイルが対象です。

- lambda-handler.py

手順のファイルはありません。  
Python 3.x のLambda関数を作成して、Lambda関数URLを有効にします。

## ELB

以下の2ファイルが対象です。

- elb-sorry-html.txt
- elb-instruction.md

手順のファイルは elb-instruction.md です。  

## API Gateway

以下の2ファイルが対象です。

- api-gateway-swagger.json
- api-gateway-instruction.md

手順のファイルは api-gateway-instruction.md です。  
