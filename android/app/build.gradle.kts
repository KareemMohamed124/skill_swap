plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
<<<<<<< HEAD
    id("com.google.gms.google-services")
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
}

android {
    namespace = "com.example.skill_swap"
    compileSdk = 36
<<<<<<< HEAD
    ndkVersion = "28.2.13676358"

    defaultConfig {
        applicationId = "com.example.skill_swap"

        // ⚠️ مهم جدًا: Jitsi 11 يحتاج 26
        minSdk = 26

=======
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.skill_swap"
        minSdk = flutter.minSdkVersion
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
<<<<<<< HEAD
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "1.8"
=======
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
<<<<<<< HEAD
            isMinifyEnabled = false
            isShrinkResources = false
=======
            isMinifyEnabled = true
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
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
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")

<<<<<<< HEAD
    // Fix logging / SLF4J
    implementation("org.slf4j:slf4j-api:2.0.13")
    implementation("org.slf4j:slf4j-simple:2.0.13")

    // Java desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    // Pusher (لو مستخدماه)
    implementation("com.pusher:pusher-java-client:2.2.5")
}
=======
    // Force correct Pusher Java Client version
    implementation("com.pusher:pusher-java-client:2.2.5")
}
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
