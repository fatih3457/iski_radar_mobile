import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// key.properties dosyasını okumak için
val keyProperties = Properties()
// Artık dosya bir üst dizinde olduğu için rootProject.file() yeterli
val keyPropertiesFile = rootProject.file("key.properties")
if (keyPropertiesFile.exists()) {
    keyProperties.load(FileInputStream(keyPropertiesFile))
}

android {
    namespace = "com.fatih.iskiradar"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    signingConfigs {
        register("release") {
            // Artık dosya yolu basit olduğu için doğrudan file() kullanabiliriz
            val storeFile = if (keyProperties.getProperty("storeFile") != null) rootProject.file(keyProperties.getProperty("storeFile")) else null
            if (storeFile != null && storeFile.exists()) {
                this.storeFile = storeFile
                storePassword = keyProperties.getProperty("storePassword")
                keyAlias = keyProperties.getProperty("keyAlias")
                keyPassword = keyProperties.getProperty("keyPassword")
            }
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    defaultConfig {
        applicationId = "com.fatih.iskiradar"
        minSdk = 21
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}