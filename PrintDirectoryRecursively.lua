-- luarocks install LuaFileSystem
local lfs = require "lfs"
require "stack"

File = {path=nil, name=nil, mode=nil}
function File:new(path, name, mode)
    if not path or not name or not mode then return nil end
    local file = {
        path=path,
        name=name,
        mode=mode
    }
    setmetatable(file, self)
    self.__index = self
    return file
end

local function getFileFromPath(path)
    if not path or path == '' then return nil end

    local name = path:sub(path:find("/[^/]*$")+1, path:len())
    local mode = lfs.attributes(path)["mode"]
    return File:new(path, name, mode)
end

local function get_dir_obj_recursive(path)
    local stack = Stack:new()
    
    local iter, dir_obj = lfs.dir(path)

    local item = iter(dir_obj)
    while item do
        local file_path = path .. '/' .. item
        local file = getFileFromPath(file_path)
        local recurse = file.mode == 'directory' and file.name ~= '.' and file.name ~= '..'
        local sItem = StackItem:new(file)
        stack:push(sItem)
        sItem.data.contents = recurse and get_dir_obj_recursive(file.path) or nil
        item = iter(dir_obj)
    end
    
    return not stack:isEmpty() and stack or nil
end

local function print_dir_objs(stack, depth) -- ──
    depth = depth or 0

    local prefix = ''
    for i=1, depth do
        prefix = prefix .. '|   '
    end
    
    local sItem = stack:pop()
    while sItem do
        local file = sItem.data
        if file.name ~= '.' and file.name ~= '..' then
            print(prefix .. (stack:peek() and '|──' or '└──') .. file.name)
            if file.contents then
                print_dir_objs(file.contents:reverse(), depth + 1)
            end
        end
        sItem = stack:pop()
    end
end

local files = get_dir_obj_recursive(lfs.currentdir())
print_dir_objs(files:reverse())