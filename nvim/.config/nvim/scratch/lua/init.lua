print("Hello, World!")

local function sum(a, b)
    return a + b
end

print(sum(3, 5))

local table = { 1, 2, 3, 4, 5 }

for i, v in ipairs(table) do
    print("Index:", i, "Value:", v)
end
