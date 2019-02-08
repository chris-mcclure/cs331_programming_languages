#!/usr/bin/env lua
-- Chris McClure 
-- HW2 lua
-- Last revision date: 2/7/19
-- Purpose: functions being tested for hw2


local pa2 = {}
-- mapTable(f, t) takes a function and a table. 
-- It calls the function passed, adds 10 to values in the table, and
-- returns the table. 
-- Ex. tbl = {[abc]=4, [true]=-14, [5] = 7} returns
-- tbl{ ["abc"]=14, [true]=-4, [5]=17 } 

function pa2.mapTable(f, t)
	for k, v in pairs(t) do
		t[k] = f(v)
	end
	return t
end

local function addTen(n)
	return n + 10
end


-- concatMax(m, n) returns the passed string concatenated with itself
-- up to the passed number. (Ex. concatMax("abc", 7) returns "abcabc").
-- If the length of the string is greater than the number passed, the 
-- function returns the empty string.

function pa2.concatMax(m, n)
	if (#m > n) then   -- if the length of the string > number, 
		return "" -- then return the empty string.
	else		
		local initial_string = m -- otherwise, store the value of m for later use
		for i = 1, math.floor(n/#m) - 1, 1 do --  i <= floor of (number/length of string) - 1
			m = m .. initial_string -- concatenate m with the initial string.
		end
		return m
	end
end


-- collatz takes a number k. If k is equal to 1, then the 
-- function returns and we're done. If k is odd, then 
-- collatz is called with 3(k)+1. Otherwise, k is even 
-- and collatz is called with k/2. 
function pa2.collatz(k)
	if k == 1 then
		-- io.write(k.. " ")
		-- print("DONE")
		return 1
	elseif (k%2 == 0) then
		-- io.write(k.. " ")
		collatz(k/2)
	else
		-- io.write(k.. " ")
		collatz((k*3)+1)
	end
end

return pa2
-- -- ******* TESTING FUNCTIONS ******

-- -- ******* function concatMax(m, n) *******
-- io.write("******* FUCNTION MAPTABLE *******\n")
-- io.write("Testing concatMax with 13: " .. concatMax("abc", 13).."\n")
-- io.write("Testing concatMax with 20: " .. concatMax("aardvark", 20).."\n")
-- io.write("Testing concatMax with 10: " .. concatMax("aardvark", 10).."\n")
-- io.write("Testing concatMax with 5: " .. concatMax("aardvark", 5).."\n")

-- io.write("\n")

-- -- ******* function mapTable(f, t) *******
-- io.write("******* FUCNTION MAPTABLE *******\n")
-- tbl = {[2]=1, ["abc"]=20, [true] = -10, ["xyz"] = -127, [false] = 14,}
-- -- io.write(mapTable(addTen, tbl))
-- tbl1 = mapTable(tbl, addTen)
-- for k, v in pairs(tbl1) do
-- 	print("v: " .. v)
-- end
-- io.write("\n")
-- -- ******* function collatz(k) *******
-- io.write("******* FUCNTION COLLATZ *******\n")
-- io.write("Testing collatz with 9: \n")
-- collatz(9)
-- io.write("\n")
-- io.write("Testing collatz with 3: \n")
-- collatz(3)
-- io.write("\n")
-- io.write("Testing collatz with 1: \n")
-- collatz(1)

-- io.write("\n")

-- -- ******* coroutine backsubs *******
-- io.write("******* COROUTINE BACKSUBS *******\n")

-- io.write("\n")


