## Açıklama

Bu script kullanıcının docker üzerinden yaptığı build ve run işlemleri için yardımcı bir araçtır. Kullancı üzerinde çalıştığı dizinde `--mode` ile ne yapılacağını seçtikten sonra o moda uygun parametreler ile işlem yapabilir. Örnek olması açısından bir python uygulaması eklenmiştir.

### Build Modu

Kullanıcı burada dizindeki uygulamayı docker image haline getirebilir. Eğer `registry` parametresi ile kullanılırsa build edilen image belirtilen registrye push edilir.

### Deploy Modu

Build edilen image belirtilen argümanlara göre çalıştırılır

### Template Modu

Burda kullanıcıya verilecek template uygulamalar çalıştırılır.
> Template modu henüz tamamlanmadı :: docker compose kullanılarak hazırlanacak
