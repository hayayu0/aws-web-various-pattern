mkdir /opt/bitnami/nginx/html/sorry
echo '<!DOCTYPE html>
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
    <img src="data:image/png;base64,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" alt="サンプル株式会社ロゴ">
    <hr>
      <h1>ただいまメンテナンス中です(Lightsail版)</h1>
    <hr>
    <p>
      ただいまサービスを停止しています。<br>
      ユーザーの皆様にはご不便をおかけしますが、今しばらくお待ち下さい。<br>
    </p>
</body>
</html>' > /opt/bitnami/nginx/html/sorry/index.html
