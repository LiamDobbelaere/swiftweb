import prologue
import std/[json]
import rpi

proc root(ctx: Context) {.async.} =
  await ctx.staticFileResponse("./res/index.html", "")

proc status(ctx: Context) {.async.} =
  resp jsonResponse(%* {
    "cpuTemp": measureCpuTemp(),
    "gpuTemp": measureGpuTemp() 
  })

let
  env = loadPrologueEnv(".env")
  settings = newSettings(appName = env.getOrDefault("appName", "Prologue"),
                         debug = env.getOrDefault("debug", true),
                         address = env.getOrDefault("address", ""),
                         port = Port(env.getOrDefault("port", 8080)))
let app = newApp(settings)
app.get("/status", status)
app.get("/", root)
app.run()
