allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val rootProjectBuildDir = project.layout.buildDirectory
tasks.register<Delete>("clean") {
    delete(rootProjectBuildDir)
}
