#!/usr/bin/env lua
-- Chris McClure 
-- HW2 lua
-- Last revision date: 2/7/19
-- Purpose: functions being tested for hw2


--module pa2 = {}

function mapTable(m, n)
	-- body
end


-- concatMax(m, n) returns the passed string concatenated with itself
-- up to the passed number. (Ex. concatMax("abc", 7) returns "abcabc").
-- If the length of the string is greater than the number passed, the 
-- function returns the empty string.
function concatMax(m, n)
	if (#m > n) then   -- if the length of the string > number, 
		return "hello" -- then return the empty string.
	else		
		local initial_string = m -- otherwise, store the value of m for later use
		for i = 1, math.floor(n/#m) - 1, 1 do --  i <= floor of (number/length of string) - 1
			m = m .. initial_string -- concatenate m with the initial string.
		end
		return m
	end
end



function collatz(k)
end

io.write("Testing concatMax with -1: " .. concatMax("abc", -1) .. "\n")
io.write("Testing concatMax with 0: " .. concatMax("abc", 0) .. "\n")
io.write("Testing concatMax with 1: " .. concatMax("abc", 1) .. "\n")
io.write("Testing concatMax with 2: " .. concatMax("abc", 2) .. "\n")
io.write("Testing concatMax with 3: " .. concatMax("abc", 3) .. "\n")
io.write("Testing concatMax with 6: " .. concatMax("abc", 6) .. "\n")
io.write("Testing concatMax with 7: " .. concatMax("abc", 7) .. "\n")



-- io.write(concatMax("abc", 10) .. "\n")
-- io.write(concatMax("132adbz", 50) .. "\n")


