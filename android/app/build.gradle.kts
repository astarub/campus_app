import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { keystoreProperties.load(it) }
}

android {
    namespace = "de.asta_bochum.campus_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Flag to enable support for the new language APIs
        isCoreLibraryDesugaringEnabled = true
        // Sets Java compatibility to Java 11
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // Application ID: https://developer.android.com/studio/build/application-id.html
        applicationId = "de.asta_bochum.campus_app"
        
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Add the Dart define flag for Cronet HTTP without Play Services
        applicationVariants.all { 
            mergedFlavor.manifestPlaceholders["cronetHttpNoPlay"] = "true"
        }
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as? String
            keyPassword = keystoreProperties["keyPassword"] as? String
            storeFile = keystoreProperties["storeFile"]?.toString()?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as? String
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            signingConfig = signingConfigs.getByName("release")

            isMinifyEnabled = true
            isShrinkResources = true

            // preserve entire Flutter wrapper code
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Dependencies for Mensa card PopupActivity
    implementation("org.jetbrains.kotlin:kotlin-stdlib:2.2.10")
    implementation("androidx.appcompat:appcompat:1.7.1")
    implementation("androidx.appcompat:appcompat-resources:1.7.1")

    // `desugar_jdk_libs` is a core Android development library that 
    // enables you to use modern Java features and APIs in your app 
    // even on older Android devices with lower API levels. 
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    // Remove Campus App's requirement of Google Play Services
    //
    // The Dio packages uses [cronet_http] libary to perform network requests. 
    // At default, this libary depends on Google Play services instead of 
    // of the embedded version of Cronet. Setting the embedded version (based on
    // native libaries) here will remove the dependency on Google Play services.
    //
    // Note: https://github.com/cfug/dio/issues/2042
    // Note: https://github.com/dart-lang/http/blob/master/pkgs/cronet_http/android/build.gradle
    // Note: https://mvnrepository.com/artifact/org.chromium.net/cronet-embedded
    //
    implementation("org.chromium.net:cronet-embedded:119.6045.31")
}