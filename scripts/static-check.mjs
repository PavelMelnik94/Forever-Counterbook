import fs from "node:fs";
import path from "node:path";
import luaparse from "luaparse";
function luaFiles(directory) {
  return fs.readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const full = path.join(directory, entry.name);
    if (entry.isDirectory()) return luaFiles(full);
    return entry.name.endsWith(".lua") ? [full] : [];
  });
}
const files = [...luaFiles("src"), ...luaFiles("tests")];
let failed = false;
for (const file of files) {
  try { luaparse.parse(fs.readFileSync(file, "utf8"), { luaVersion: "5.1" }); console.log(`OK ${file}`); }
  catch (error) { failed = true; console.error(`ERROR ${file}: ${error.message}`); }
}
if (failed) process.exit(1);

