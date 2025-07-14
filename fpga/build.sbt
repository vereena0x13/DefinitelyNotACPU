ThisBuild / version         := "0.1.0"
ThisBuild / scalaVersion    := "2.13.14"
ThisBuild / organization    := "gay.vereena"

ThisBuild/scalacOptions ++= Seq("-unchecked", "-deprecation")

val spinalVersion = "1.12.2"
val spinalCore = "com.github.spinalhdl" %% "spinalhdl-core" % spinalVersion
val spinalLib = "com.github.spinalhdl" %% "spinalhdl-lib" % spinalVersion
val spinalIdslPlugin = compilerPlugin("com.github.spinalhdl" %% "spinalhdl-idsl-plugin" % spinalVersion)

lazy val projectname = (project in file("."))
  .settings(
    Compile / scalaSource := baseDirectory.value / "spinal",
    libraryDependencies ++= Seq(spinalCore, spinalLib, spinalIdslPlugin)
  )

fork := true