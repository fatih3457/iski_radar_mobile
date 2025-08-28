# İSKİ Radar Mobil Uygulaması 📱

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue.svg?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android_%7C_iOS-green.svg)
![State Management](https://img.shields.io/badge/State_Management-setState-lightgrey.svg)

Bu proje, **İSKİ Radar** adlı Full Stack projenin **Mobil Frontend** katmanıdır. Temel amacı, [İSKİ Radar API](https://github.com/fatih3457/iski-radar-api) tarafından sunulan canlı baraj doluluk verilerini, kullanıcı dostu ve bilgilendirici bir mobil arayüzde sunmaktır.

## 🌟 Projenin Amacı

Bu proje, aşağıdaki hedeflere ulaşmak için geliştirilmiştir:
-   **Flutter** kullanarak platformlar arası (cross-platform), modern ve performanslı bir mobil uygulama geliştirme becerisini sergilemek.
-   Canlı bir REST API'sine bağlanma, gelen JSON verisini ayrıştırma (parsing) ve asenkron işlemleri yönetme tecrübesi kazanmak.
-   Kullanıcı deneyimini (UX) zenginleştiren modern mobil uygulama özellikleri (Pull-to-Refresh, dinamik grafikler, sayfa navigasyonu vb.) uygulamak.
-   Uygulamaya profesyonel bir görünüm kazandırmak için ikon ve açılış ekranı gibi varlıkları (assets) yönetmek.

## ✨ Özellikler

-   **Canlı Veri:** Uygulama, AWS üzerinde çalışan canlı bir backend servisinden anlık baraj doluluk oranlarını çeker.
-   **Görsel Durum Göstergeleri:** Her barajın doluluk oranı, durumunu (iyi, orta, kötü) bir bakışta gösteren renk kodlamalı ilerleme çubukları ile görselleştirilmiştir.
-   **Çek-Yenile (Pull-to-Refresh):** Kullanıcılar, listeyi aşağı çekerek verilerin en güncel halini anında alabilirler.
-   **Dinamik Bilgiler:** Bir baraja tıklandığında açılan detay sayfasında, o barajın hacim bilgileri gibi bilgiler yer alır.
-   **Profesyonel Görünüm:** Uygulamanın kendine özel bir uygulama ikonu ve uygulama başlarken kullanıcıyı karşılayan bir açılış ekranı (splash screen) bulunmaktadır.
-   **Hata Yönetimi:** API'ye ulaşılamadığı veya bir hata oluştuğu durumlarda kullanıcıya bilgilendirici hata mesajları ve "Tekrar Dene" butonu gösterilir.

## 🛠️ Kullanılan Teknolojiler

-   **Framework:** Flutter 3.x
-   **Dil:** Dart 3.x
-   **Asenkron Programlama:** `Future`, `async/await`
-   **Paketler:**
    -   `http`: REST API istekleri yapmak için.
    -   `fl_chart`: Dinamik ve şık grafikler çizmek için.
    -   `flutter_launcher_icons`: Platforma özel uygulama ikonlarını otomatik oluşturmak için.
    -   `flutter_native_splash`: Platforma özel açılış ekranlarını otomatik oluşturmak için.
-   **State Management:** `StatefulWidget` ve `setState` (Basit ve etkili durum yönetimi için).

## 🚀 Projeyi Lokalde Çalıştırma

1.  **Flutter Kurulumu:** Bilgisayarınızda Flutter SDK'sının kurulu olduğundan emin olun.
2.  **Projeyi Klonlayın:**
    ```bash
    git clone https://github.com/kullaniciadin/iski_radar_mobile.git
    cd iski_radar_mobile
    ```
3.  **Bağımlılıkları Yükleyin:**
    ```bash
    flutter pub get
    ```
4.  **Backend'i Çalıştırın:**
    -   Bu mobil uygulamanın çalışabilmesi için, veri sağlayan [İSKİ Radar API](https://github.com/fatih3457/iski-radar-api)'sinin lokalde veya canlı bir sunucuda çalışıyor olması gerekmektedir.
    -   Lokalde çalıştırıyorsanız, `lib/main.dart` ve `lib/dam_detail_page.dart` dosyalarındaki `apiUrl` değişkeninin `http://10.0.2.2:8090/...` gibi lokal geliştirme adresini gösterdiğinden emin olun.
5.  **Uygulamayı Çalıştırın:**
    -   Bir emülatör veya fiziksel bir cihaz bağlayın.
    -   Projeyi IDE'niz (IntelliJ, VS Code, Android Studio) üzerinden veya komut satırından çalıştırın:
    ```bash
    flutter run
    ```

## 🖥️ Backend Projesi

Bu mobil uygulamanın bağlandığı Spring Boot backend servisine göz atmak için:
➡️ **[İSKİ Radar API Deposu](https://github.com/fatih3457/iski-radar-api)**
