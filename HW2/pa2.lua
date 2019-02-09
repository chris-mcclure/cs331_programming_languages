#!/usr/bin/env lua
-- Chris McClure 
-- HW2 lua
-- Last revision date: 2/7/19
-- Purpose: functions being tested for hw2

local pa2 = {}


-- ******* FUNCTION MAPTABLE *******
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


-- ******* FUNCTION CONCATMAX *******
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


-- ******* FUNCTION COLLATZ *******
-- collatz takes a number k and returns an iterator.
--  If k is equal to 1, then the function returns 
--and we're done. If k is odd, then collatz is called 
--with 3(k)+1. Otherwise, k is even and collatz is called with k/2. 
function pa2.collatz(k)
	local flag = false -- flag is set to true once a 1 has been seen
	function iter(dummy)
		local num = k
		if k == 1 then 
			if flag == false then
				flag = true -- 1 has been seen 
				return num  -- next time we see a 1, we return nil
			else 
				return nil
			end
		elseif k%2 == 0 then 
			num = k
			k = k/2
		else
			num = k
			k = 3*k + 1
		end
		return num
	end
	return iter, nil, nil
end


-- ******* COROUTINE BACKSUBS *******
-- coroutine backsSubs takes in a string "s" and yields all substrings
-- of the reverse of "s", including the empty string.
-- ex.) s = "abc", backSubs yields {"", "c", "b", "a", "cb", "ba", "cba"}
function pa2.backSubs(s)
	local count = 0 -- loop counter 
	local start = 0 -- start of string
	local dist = 0 -- indexed character
	local n =string.len(s) -- length of string
	local str_reverse = string.reverse(s) 
	local num_substr = (n*(n+1)/2)+1 -- the number of possible substrings, including empty string

	for sub_counter = 1, num_substr do
		coroutine.yield(string.sub(str_reverse, start, count))
		count = count + 1
		start = start + 1
		if count == n+1 then
			dist = dist + 1 -- distance betweeen bounds
			start = 1 -- go back to the first non empty character in the string
			count = start + dist -- far bound = near bound + distance between bounds
		end
	end
end

return pa2 -- return module to caller


