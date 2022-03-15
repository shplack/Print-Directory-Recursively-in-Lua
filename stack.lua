Stack = {top=nil, size=0}
function Stack:new()
    local stack = {top=nil, size=0}
    setmetatable(stack, self)
    self.__index = self
    return stack
end

function Stack:isEmpty()
    if self.size >0 then
        return false
    end

    return true
end

function Stack:push(sItem)
    if not sItem then return false end

    if self.size > 0 then
        sItem.next = self.top
    end

    self.top = sItem
    self.size = self.size + 1
    return true
end

function Stack:pop()
    if self:isEmpty() then return nil end

    local sItem = self.top
    self.top = self.top.next
    self.size = self.size - 1

    return sItem
end

function Stack:peek()
    if self:isEmpty() then return nil end
    return self.top
end

function Stack:reverse()
    local reverse = Stack:new()

    local function deepcopy(orig, copies)
        copies = copies or {}
        local orig_type = type(orig)
        local copy
        if orig_type == 'table' then
            if copies[orig] then
                copy = copies[orig]
            else
                copy = {}
                copies[orig] = copy
                for orig_key, orig_value in next, orig, nil do
                    copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
                end
                setmetatable(copy, deepcopy(getmetatable(orig), copies))
            end
        else -- number, string, boolean, etc
            copy = orig
        end
        return copy
    end

    local sItem = self.top
    while sItem do
        reverse:push(deepcopy(sItem))
        sItem = sItem.next
    end
    
    return reverse
end

function Stack:print(func)
    if self:isEmpty() then
        print("Stack is empty")
        return
    end

    local sItem = self.top
    for i=1, self.size do
        print(("index: %i\tdata: %s"):format(i, func(sItem.data)))
        sItem = sItem.next
    end
end


StackItem = {data=nil, next=nil}
function StackItem:new(data)
    local sItem = {data=data, next=nil}
    setmetatable(sItem, self)
    self.__index = self
    return sItem
end