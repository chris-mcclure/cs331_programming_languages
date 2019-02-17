-- Chris McClure
-- CS331 HW3
-- Last Date Modified: 2/15/19
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


    -- ***** States *****

    local DONE   = 0
    local START  = 1
    local LETTER = 2
    local DIGIT  = 3
    local DIGDOT = 4
    local DOT    = 5
    local PLUS   = 6
    local MINUS  = 7
    local STAR   = 8
    local EXP	 = 9

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
	    	add1()
	    	state = LETTER
    	elseif isDigit(ch) then
    		add1()
    		state = DIGIT
    	elseif ch == "." then
    		add1()
    		state = DOT
    	elseif ch == "+" then
    		add1()
    		state = PLUS
    	elseif ch == "-" then
    		add1()
    		state = MINUS
    	elseif ch == "*" or ch == "/" or ch == "=" 
    		or ch == "&" or ch == "|" or ch == "!" or 
    		ch == "<" or ch == ">" or ch == "%" or ch == "[" 
    		or ch == "]" then
    		add1()
    		state = STAR
    	else
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
    		else
    			category = lexit.ID
    		end
    	end
    end

	-- *********** handle_DIGIT() **********
    local function handle_DIGIT()
    	if isDigit(ch) then 
    		add1()
    	elseif ch == "." then
   			add1()
   			state = DIGDOT
   		else
   			state = DONE
   			category = lexit.NUMLIT
   		end
   	end
    

    local function handle_DIGDOT()
        if isDigit(ch) then
            add1()
        else
            state = DONE
            category = lexit.NUMLIT
        end
    end

    local function handle_DOT()
        if isDigit(ch) then
            add1()
            state = DIGDOT
        else
            state = DONE
            category = lexit.OP
        end
    end

    local function handle_PLUS()
        if ch == "+" or ch == "=" then
            add1()
            state = DONE
            category = lexit.OP
        elseif isDigit(ch) then
            add1()
            state = DIGIT
        elseif ch == "." then
            if isDigit(nextChar()) then
                add1()  -- add dot to lexeme
                add1()  -- add digit to lexeme (OPTIONAL)
                state = DIGDOT
            else  -- lexeme is just "+"; do not add dot to lexeme
                state = DONE
                category = lexit.OP
            end
        else
            state = DONE
            category = lexit.OP
        end
    end

    local function handle_MINUS()
        if ch == "-" or ch == "=" then
            add1()
            state = DONE
            category = lexit.OP
        elseif isDigit(ch) then
            add1()
            state = DIGIT
        elseif ch == "." then
            if isDigit(nextChar()) then
                add1()  -- add dot to lexeme
                add1()  -- add digit to lexeme (OPTIONAL)
                state = DIGDOT
            else  -- lexeme is just "-"; do not add dot to lexeme
                state = DONE
                category = lexit.OP
            end
        else
            state = DONE
            category = lexit.OP
        end
    end

    local function handle_STAR()  -- Handle * or / or =
        if ch == "=" or ch == "|" or ch == "&" then
            add1()
            state = DONE
            category = lexit.OP
        else
            state = DONE
            category = lexit.OP
        end
    end

    local function handle_EXP()
    	print("IN HANDLE_EXP")
    	if nextChar() == "-" then
    		state = DONE
    		category = lexit.MAL
    	else
    		add1()
    		state = EXP
    		category = lexit.NUMLIT
    	end
	end


    handlers = {
	    [DONE]=handle_DONE,
	    [START]=handle_START,
	    [LETTER]=handle_LETTER,
	    [DIGIT]=handle_DIGIT,
	    [DIGDOT]=handle_DIGDOT,
	    [DOT]=handle_DOT,
	    [PLUS]=handle_PLUS,
	    [MINUS]=handle_MINUS,
	    [STAR]=handle_STAR,
	    [EXP]=handle_EXP,
	}

    local function getLex(dummy1, dummy2)
    	if pos > program:len() then
    		return nil, nil
    	end
    	print("PROGRAM: " .. program)
    	lexstr = ""
    	state = START
    	while state ~= DONE do
    		ch = currChar()
    		handlers[state]()
    	end
    	skipWhiteSpace()
    	print("CATEGORY: " .. category)
    	return lexstr, category
    end

    pos = 1
    skipWhiteSpace()
    return getLex, nil, nil
end



return lexit