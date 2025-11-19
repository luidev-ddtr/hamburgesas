buildscript {
    val kotlin_version = "1.8.21" // Usamos 'val' y comillas dobles
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        // La dependencia del plugin de Android para Gradle
        classpath("com.android.tools.build:gradle:8.0.0") // Paréntesis y comillas dobles

        // *************************************************************
        // 🚨 PLUGIN DE GOOGLE SERVICES (Corregido para Kotlin)
        // *************************************************************
        classpath("com.google.gms:google-services:4.4.1")

        // Dependencia de Kotlin
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Configuración de la carpeta de build (Esto ya estaba en Kotlin, se deja igual)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}