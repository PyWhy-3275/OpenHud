fs = require("filesystem")
 
files = { 
    { pastebin = "DGapqufy", path = "/usr/bin", filename = "openhud.lua", label = "launcher" },
    { pastebin = "JDJJPgMU", path = "/usr/lib/openglasses", filename = "open-hud.lua", label = "lib" }
}

function fetchFile(f)
    local file = f.path .. "/" .. f.filename
    if not fs.isDirectory(f.path) then fs.makeDirectory(f.path); end
    if fs.exists(file) then fs.remove(file); end
    
    print("fetching "..f.label)
    os.execute("pastebin get ".. f.pastebin .." " .. file)  
end
 
 
for i=1,#files do
    fetchFile(files[i])
    os.sleep(0)
end
 
print("\n...done! run with 'openhud'")