--debug.getinfo(1).source
print("cwd:")
print(string.gsub(debug.getinfo(1).source, "^@(.+/)[^/]+$", "%1"))

print("pkgpath")
print(package.path)

function emit_build_lua(module)
   print("emit_build_lua entry, module: " .. module)
   print("bazel.packages:")
   for k,v in pairs(bazel.packages) do
      print(k,v)
      for kk,vv in pairs(v) do
         print("  ", kk,vv)
      end
      print("modules:")
      for km,vm in pairs(v.modules) do
         print("== ", km, vm)
         for kkm,vvm in pairs(vm) do
            print("\t  ", kkm, vvm)
         end
      end
   end
   return "ok"
end

function init()
   print("LUA init")
   dd = require("datadumper")
   print("LUA MODULES:\n",(package.path:gsub("%;","\n\t")),"\n\nC MODULES:\n",(package.cpath:gsub("%;","\n\t")))
   print("package.path: ")
   print(package.path)

   print("bazel table:")
   print(DataDumper(bazel))
   -- print(to_string(bazel))
   -- for k,v in pairs(bazel) do
   --    print(k,v)
   -- end
   -- print("packages:")
   -- for pnm,pkg in pairs(bazel.packages) do
   --    print("pkg: " .. pnm) --, pkg)
   --    print(" path: " .. pkg.path)
   --    print(" modules:")
   --    for mname,m in pairs(pkg.modules) do
   --       print("  " .. mname)
   --       for sfile,sfile_tbl in pairs(m) do
   --          print("    " .. sfile)
   --          print("      name: " .. sfile_tbl.name)
   --          print("      deps: ") -- , sfile_tbl.deps)
   --          print("        modules:") -- , sfile_tbl.deps)
   --          for _,d in pairs(sfile_tbl.deps.modules) do
   --             print("          dep: ", d.dep)
   --          end
   --       end
   --    end
   -- end
   print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
   return "ok"
end

-- http://lua-users.org/wiki/TableSerialization
function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs (tt) do
      table.insert(sb, string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        table.insert(sb, key .. " = {\n");
        table.insert(sb, table_print (value, indent + 2, done))
        table.insert(sb, string.rep (" ", indent)) -- indent it
        table.insert(sb, "}\n");
      elseif "number" == type(key) then
        table.insert(sb, string.format("\"%s\"\n", tostring(value)))
      else
        table.insert(sb, string.format(
            "%s = \"%s\"\n", tostring (key), tostring(value)))
       end
    end
    return table.concat(sb)
  else
    return tt .. "\n"
  end
end

function to_string( tbl )
    if  "nil"       == type( tbl ) then
        return tostring(nil)
    elseif  "table" == type( tbl ) then
        return table_print(tbl)
    elseif  "string" == type( tbl ) then
        return tbl
    else
        return tostring(tbl)
    end
end

function table.show(t, name, indent)
   local cart     -- a container
   local autoref  -- for self references

   --[[ counts the number of elements in a table
   local function tablecount(t)
      local n = 0
      for _, _ in pairs(t) do n = n+1 end
      return n
   end
   ]]
   -- (RiciLake) returns true if the table is empty
   local function isemptytable(t) return next(t) == nil end

   local function basicSerialize (o)
      local so = tostring(o)
      if type(o) == "function" then
         local info = debug.getinfo(o, "S")
         -- info.name is nil because o is not a calling level
         if info.what == "C" then
            return string.format("%q", so .. ", C function")
         else 
            -- the information is defined through lines
            return string.format("%q", so .. ", defined in (" ..
                info.linedefined .. "-" .. info.lastlinedefined ..
                ")" .. info.source)
         end
      elseif type(o) == "number" or type(o) == "boolean" then
         return so
      else
         return string.format("%q", so)
      end
   end

   local function addtocart (value, name, indent, saved, field)
      indent = indent or ""
      saved = saved or {}
      field = field or name

      cart = cart .. indent .. field

      if type(value) ~= "table" then
         cart = cart .. " = " .. basicSerialize(value) .. ";\n"
      else
         if saved[value] then
            cart = cart .. " = {}; -- " .. saved[value] 
                        .. " (self reference)\n"
            autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
         else
            saved[value] = name
            --if tablecount(value) == 0 then
            if isemptytable(value) then
               cart = cart .. " = {};\n"
            else
               cart = cart .. " = {\n"
               for k, v in pairs(value) do
                  k = basicSerialize(k)
                  local fname = string.format("%s[%s]", name, k)
                  field = string.format("[%s]", k)
                  -- three spaces between levels
                  addtocart(v, fname, indent .. "   ", saved, field)
               end
               cart = cart .. indent .. "};\n"
            end
         end
      end
   end

   name = name or "__unnamed__"
   if type(t) ~= "table" then
      return name .. " = " .. basicSerialize(t)
   end
   cart, autoref = "", ""
   addtocart(t, name, indent)
   return cart .. autoref
end
