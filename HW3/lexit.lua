-- Chris McClure
-- CS331 HW3
-- Last Date Modified: 2/17/19
-- lexit.lua

local lexit = {}

-- Constants that represent the the lexeme categories.
-- Readable names are in lexit.catnames
lexit.KEY 		= 1
lexit.ID 		= 2
lexit.NUMLIT	= 3
lexit.STRLIT	= 4
lexit.OP		= 5
lexit.PUNCT		= 6
lexit.MAL 		= 7


-- catnames
-- table of lexeme category names
lexit.catnames = {
	"Keyword", 
	"Identifier",
	"NumericLiteral",
	"StringLiteral", 
	"Operator", 
	"Punctuation", 
	"Malformed",
}

-- isLetter
-- Fucntion returns true if the parameter passed is within the bounds of upper
-- and lower-case a and z (inclusive), false otherwise.
local function isLetter(s)
	if s:len() ~= 1 then
		return false
	elseif s >= "A" and s <= "Z" then
		return true
	elseif s >= "a" and s <= "z" then 
		return true
	else 
		return false
	end
end

-- isDigit
-- Function returns true if the parameter passed is within 0 and 9 (inclusive), false otherwise.
local function isDigit(s)
	if s:len() ~= 1 then
		return false
	elseif s >= "0" and s <= "9" then
		return true
	else
		return false
	end
end

-- isWhiteSpace
-- Function returns false if the string length isn't equal to 1. 
-- Function returns true if the string is equal to
-- any of the whitespace characters.
local function isWhiteSpace(s)
	if s:len() ~= 1 then
		return false
	elseif s == " " or s == "\t" or s == "\n"
		or s == "\r" or s == "\f" or s == "\v" then
		return true
	else
		return false
	end
end

-- isIllegal
-- Function returns false if the character passed is legal 
-- according to the lexeme specification. 
local function isIllegal(s)
	if s:len() ~= 1 then 
		return false
	elseif isWhiteSpace(s) then
		return false
	elseif s >= " " and s <= "~" then 
		return false
	else 
		return true
	end
end

function lexit.lex(program)
	-- local variables borrowed from Dr. Chappell's lexit.lua.
	local pos       -- Index of next character in program
	                -- INVARIANT: when getLexeme is called, pos is
	                --  EITHER the index of the first character of the
	                --  next lexeme OR program:len()+1
	local state     -- Current state for our state machine
	local ch        -- Current character
	local lexstr    -- The lexeme, so far
	local category  -- Category of lexeme, set when state set to DONE
	local handlers  -- Dispatch table; value created later
	local prevstr 	-- previous string
	local prevcat	-- previous category
	local prevstate  -- previous state
    local prevchar
    local expFlag 

    -- ***** States *****

    local DONE   = 0
    local START  = 1
    local LETTER = 2
    local DIGIT  = 3
    local DOT    = 4
    local PLUS   = 5
    local MINUS  = 6
    local STAR   = 7
    local EXP	 = 8
    local STR    = 9

    -- DR. CHAPPELL'S UTITLITY FUNCTIONS FROM lexit.LUA
    -- ***** Character-Related Utility Functions *****

    -- currChar
    -- Return the current character, at index pos in program. Return
    -- value is a single-character string, or the empty string if pos is
    -- past the end.
    local function currChar()
    	-- print("POS: " .. pos)
        return program:sub(pos, pos)
    end

    -- nextChar
    -- Return the next character, at index pos+1 in program. Return
    -- value is a single-character string, or the empty string if pos+1
    -- is past the end.
    local function nextChar()
        return program:sub(pos+1, pos+1)
    end

    local function inTwoChars()
        return program:sub(pos+2, pos+2)
    end

    -- drop1
    -- Move pos to the next character.
    local function drop1()
        pos = pos+1
    end

    -- add1
    -- Add the current character to the lexeme, moving pos to the next
    -- character.
    local function add1()
        lexstr = lexstr .. currChar()
        drop1()
    end

    -- skip white space and everything in a comment
    local function skipWhiteSpace()
    	while true do
    		-- print("ch: " .. currChar())
    		while isWhiteSpace(currChar()) do
    			drop1() -- while the current char is a white
    			--space, keep increminting to the next char
    		end
    		if currChar() ~= "#"  then -- if the current char
    			-- doesn't equal #, then break out of the 
    			--while loop
    			break
    		end 
    		drop1()
    		while true do
    			if currChar() == "\n" or currChar() == "" then
    				drop1()
    				break
    			end
    			drop1()
    		end
    	end
    end




    local function handle_DONE()
        io.write("ERROR: 'DONE' state should not be handled\n")
        assert(0)
    end

    local function handle_START()
    	if isIllegal(ch) then
    		add1()
    		state = DONE
    		category = lexit.MAL
    	elseif isLetter(ch) or ch == "_" then
            prevchar = ch
	    	add1()
	    	state = LETTER
    	elseif isDigit(ch) then
            prevchar = ch
    		add1()
    		state = DIGIT
    	elseif ch == "+" then
            if nextChar() == "+" then
                add1()
                state = DONE
                category = lexit.OP
            else
        		add1()
        		state = PLUS
            end
    	elseif ch == "-" then
            -- prevchar = ch
    		add1()
    		state = MINUS
        elseif ch == '"' or ch == "'" then
            prevchar = ch
            add1()
            state = STR
    	elseif ch == "*" or ch == "/" or ch == "=" 
    		or ch == "&" or ch == "|" or ch == "!" or 
    		ch == "<" or ch == ">" or ch == "%" or ch == "[" 
    		or ch == "]" then
    		add1()
            prevchar = ch
    		state = STAR
    	else
            prevchar = ch
    		add1()
    		state = DONE
    		category = lexit.PUNCT
    	end
    end


    -- *********** handle_LETTER() **********
    local function handle_LETTER()
    	if isLetter(ch) or isDigit(ch) or ch == "_" then 
    		  add1()
    	else
    		state = DONE
    		if lexstr == "cr" or lexstr == "def"
    			or lexstr == "else" or lexstr == "elseif" 
    			or lexstr == "end" or lexstr == "false" or lexstr == "if" 
    			or lexstr == "readnum" or lexstr == "return" 
    			or lexstr == "true" or lexstr == "while" 
    			or lexstr == "write" then
    				category = lexit.KEY
                    prevstate = lexit.key
    		else
                prevstate = lexit.ID
    			category = lexit.ID
    		end
    	end
    end

	-- *********** handle_DIGIT() **********
    local function handle_DIGIT()
    	if isDigit(ch) then
            if prevchar == "e" and nextChar() == "e" then
                add1()
                state = DONE
                category = lexit.NUMLIT
            elseif nextChar() == "e" and prevchar == "+" 
                and expFlag == "!" then
                add1()
                state = DONE
                category = lexit.NUMLIT
            else
    		  add1()
            end  
    	elseif ch == "E" or ch == "e" then
            state = EXP
   		elseif nextChar() == "." then
   			state = DONE
   			category = lexit.PUNCT
   		else
   			state = DONE
            prevstate = lexit.NUMLIT
   			category = lexit.NUMLIT
   		end
   	end
    

    local function handle_DOT()
        if isDigit(ch) then
            add1()
            state = lexit.NUMLIT
        else
            state = DONE
            category = lexit.PUNCT
        end
    end

    local function handle_PLUS()
        if prevstate == lexit.ID or prevstate == lexit.NUMLIT
        or prevstate == lexit.KEY or
        prevstr == "true" or prevstr == "false"
        and isDigit(ch) then
            if prevstr == "*" then
                add1() 
                state = DIGIT
            else
                state = DONE
                category = lexit.OP
            end
        elseif prevstr == "e" or prevstr == "E" then
            state = DONE
            category = lexit.OP
        elseif ch == "+" then --or ch == "=" then
            if nextChar() == "=" or nextChar() == "+" then
                state = DONE
                category = lexit.OP
        	elseif isDigit(nextChar()) then
                prevchar = ch
        		add1()
        		state = DIGIT
            elseif nextChar() == "" then
                state = DONE 
                category = lexit.OP
        	else
	            add1()
	            state = DONE
	            category = lexit.OP
	        end
        elseif isDigit(ch) then
            if prevchar == "]" or prevchar == ")" then
                state = DONE
                category = lexit.OP
            else
                add1()
                state = DIGIT
            end
        else
            prevstate = lexit.OP
            state = DONE
            category = lexit.OP
        end
    end

    local function handle_MINUS()
        if prevstate == lexit.ID or prevstate == lexit.NUMLIT
        or prevstr == "true" or prevstr == "false"
        and isDigit(ch) then
            if prevstr == "*" then
                add1()
                state = DIGIT
            else
                state = DONE
                category = lexit.OP
            end
    	elseif prevstr == "e" or prevstr == "E" then
    		state = DONE
            category = lexit.OP
        elseif ch == "-" or ch == "=" then
            state = DONE
            category = lexit.OP
        elseif isDigit(ch) then
            if prevchar == "]" or prevchar == ")" then
                state = DONE
                category = lexit.OP
            else
    		    add1()
    			state = DIGIT
            end
        else
            state = DONE
            category = lexit.OP
        end
    end

    local function handle_STR()
        if ch == "\n" then
            add1()
            state = DONE
            category = lexit.MAL
        elseif ch ~= prevchar and ch ~= "" then
                add1()
        elseif ch == prevchar and ch ~= "" then
            add1()
            state = DONE
            category = lexit.STRLIT
        elseif ch ~= prevchar and ch == "" then
            state = DONE
            category = lexit.MAL
        else
            add1()
            state = DONE
            category = lexit.STRLIT
        end
    end

    local function handle_STAR()  -- Handle * or / or =
        if prevchar == "*" or prevchar == "/" and ch == "=" then
            state = DONE
            category = lexit.OP
        elseif ch == "=" then
            prevchar = ch
            add1()
            state = DONE
            category = lexit.OP
        elseif ch == "+" or ch == "-" then  
            state = DONE
            category = lexit.OP
        elseif ch == " " and nextChar() == "|" or nextChar() == "&" then
            state = DONE
            category = lexit.PUNCT
        elseif prevchar == "&" and ch == "&" then 
            add1()
            prevchar = ch
            state = DONE
            category =lexit.OP
        elseif prevchar == "|" and ch == "|" then
            add1()
            prevchar = ch
            state = DONE
            category =lexit.OP
        elseif prevchar == "&" or prevchar == "|" and ch == "" then
            state = DONE
            category = lexit.PUNCT
        else
            prevchar = ch
            prevstate = lexit.OP
            state = DONE
            category = lexit.OP
        end
    end

    local function  handle_EXP()
        if nextChar() == "+" then
            if inTwoChars() == "" then
                state = DONE
                category = lexit.NUMLIT
            elseif inTwoChars() == "e" then
                state = DONE
                category = lexit.NUMLIT
            else
                expFlag = "!"
                add1()
                state = PLUS
            end
        elseif isDigit(nextChar()) then
            prevchar = ch
            add1()
            state = DIGIT
        elseif nextChar() == "-" then
            state = DONE
            category = lexit.NUMLIT
        else
            state = DONE
            category = lexit.NUMLIT
        end
    end


    handlers = {
	    [DONE]=handle_DONE,
	    [START]=handle_START,
	    [LETTER]=handle_LETTER,
	    [DIGIT]=handle_DIGIT,
	    [DOT]=handle_DOT,
	    [PLUS]=handle_PLUS,
	    [MINUS]=handle_MINUS,
	    [STAR]=handle_STAR,
	    [EXP]=handle_EXP,
        [STR]=handle_STR
	}

    local function getLex(dummy1, dummy2)
    	if pos > program:len() then
    		return nil, nil
    	end
    	lexstr = ""
    	state = START
    	while state ~= DONE do
    		ch = currChar()
    		handlers[state]()
    	end
    	skipWhiteSpace()
    	prevstr	 = lexstr
    	return lexstr, category
    end
    pos = 1
    skipWhiteSpace()
    return getLex, nil, nil
end



return lexit