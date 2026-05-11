buildscript {
    repositories {
        google()
        mavenCentral()
<<<<<<< HEAD
        maven { setUrl("https://jitpack.io") }
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.4.2")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.22")
<<<<<<< HEAD

        // 🔥 مهم لو عندك Firebase (واضح إنك مستخدم google-services)
        classpath("com.google.gms:google-services:4.4.2")
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        maven { setUrl("https://jitpack.io") }
    }
}

<<<<<<< HEAD
// 🔥 تنظيم build folder (ده تمام عندك)
=======
>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
<<<<<<< HEAD
}

// 🧹 clean task (تمام زي ما هو)
=======
    project.evaluationDependsOn(":app")
}

>>>>>>> 4bf2966f4a190da3a09f2a3e000e0b00e0a9c4d1
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}