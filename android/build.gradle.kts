allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
// Older plugins (e.g. flutter_displaymode) compile against an outdated SDK
// that their own dependencies no longer support, so raise it for all of them.
// Plugins that already declare a newer SDK keep theirs.
subprojects {
    afterEvaluate {
        if (plugins.hasPlugin("com.android.library")) {
            extensions.findByName("android")?.withGroovyBuilder {
                val current = (getProperty("compileSdkVersion") as? String)
                    ?.removePrefix("android-")?.toIntOrNull() ?: 0
                if (current < 36) {
                    "compileSdkVersion"(36)
                } else if (current == 37) {
                    // AGP 8.x looks for "android-37", but the SDK installs it as "android-37.0".
                    "compileSdkVersion"("android-37.0")
                }
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
