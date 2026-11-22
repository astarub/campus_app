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
                // AGP reports e.g. "android-36" or "android-37.0".
                val current = (getProperty("compileSdkVersion") as? String)
                    ?.removePrefix("android-")?.substringBefore('.')?.toIntOrNull()
                if (current != null && current < 36) {
                    "compileSdkVersion"(36)
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
