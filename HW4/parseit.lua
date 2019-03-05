

-- ******* REMEMBER TO CHANGE CHAPPELLS CODE BACK TO NORMAL!!!!!!!! *******

-- Chris McClure
-- CS331 HW4
-- Last Date Modified: 3/2/19
-- Purpose: parser program being tested
-- in conjunction with lexit.lua for HW4

--[[
***** GRAMMAR *****
(1) program 	  →   	stmt_list
(2) stmt_list 	  →   	{ statement }
(3) statement 	  →   	‘write’ ‘(’ write_arg { ‘,’ write_arg } ‘)’
(4)   	|   	‘def’ ID ‘(’ ‘)’ stmt_list ‘end’
(5)   	|   	‘if’ expr stmt_list { ‘elseif’ expr stmt_list } [ ‘else’ stmt_list ] ‘end’
(6)   	|   	‘while’ expr stmt_list ‘end’
(7)   	|   	‘return’ expr
(8)   	|   	ID ( ‘(’ ‘)’ | [ ‘[’ expr ‘]’ ] ‘=’ expr )
(9) write_arg 	  →   	‘cr’
(10)   	|   	STRLIT
(11)   	|   	expr
(12) expr 	  →   	comp_expr { ( ‘&&’ | ‘||’ ) comp_expr }
(13) comp_expr 	  →   	‘!’ comp_expr
(14)   	|   	arith_expr { ( ‘==’ | ‘!=’ | ‘<’ | ‘<=’ | ‘>’ | ‘>=’ ) arith_expr }
(15) arith_expr 	  →   	term { ( ‘+’ | ‘-’ ) term }
(16) term 	  →   	factor { ( ‘*’ | ‘/’ | ‘%’ ) factor }
(17) factor 	  →   	‘(’ expr ‘)’
(18)   	|   	( ‘+’ | ‘-’ ) factor
(19)   	|   	NUMLIT
(20)   	|   	( ‘true’ | ‘false’ )
(21)   	|   	‘readnum’ ‘(’ ‘)’
(22)   	|   	ID [ ‘(’ ‘)’ | ‘[’ expr ‘]’ ] 
]]--

local parseit = {}

local lexit = require "lexit"

-- Variables

-- For lexer iteration
local iter 			-- Iterator returned by lexit.lex
local state 		-- State for above iterator (maybe not used)
local lexer_out_s 	-- return value #1 from above iterator
local lexer_out_c 	-- return value #2 from above iterator

-- For current lexeme
local lexstr = ""
local lexcat = 0

-- Symbolic Constants for AST
local STMT_LIST    = 1
local WRITE_STMT   = 2
local FUNC_DEF     = 3
local FUNC_CALL    = 4
local IF_STMT      = 5
local WHILE_STMT   = 6
local RETURN_STMT  = 7
local ASSN_STMT    = 8
local CR_OUT       = 9
local STRLIT_OUT   = 10
local BIN_OP       = 11
local UN_OP        = 12
local NUMLIT_VAL   = 13
local BOOLLIT_VAL  = 14
local READNUM_CALL = 15
local SIMPLE_VAR   = 16
local ARRAY_VAR    = 17

-- Utility Functions

-- advance
-- Go to next lexeme and load it into lexstr, lexcat.
-- Should be called once before any parsing is done.
-- Function init must be called before this function is called.
local function advance()
	-- Advance the iterator
	lexer_out_s, lexer_out_c = iter(staet, lexer_out_s)

	-- If we're not past the end, copy current lexeme into vars
	if lexer_out_s ~= nil then
		lexstr, lexcat = lexer_out_s, lexer_out_c
	else
		lexstr, lexcat = "", 0
	end
end

-- init
-- Initial call. Sets input for parsing functions.
local function init(prog)
	iter, state, lexer_out_s = lexit.lex(prog)
	advance()
end

-- atEnd
-- Return true if pos has reached end of input.
-- Function init must be called beore this function is called.
local function atEnd()
	return lexcat == 0
end


-- matchString
-- Given string, see if current lexeme string form is equal to it. If
-- so, then advance to next lexeme & return true. If not, then do not
-- advance, return false.
-- Function init must be called before this function is called.
local function matchString(s)
	if lexstr == s then 
		advance()
		return true
	else
		return false
	end
end


-- matchCat
-- Given lexeme category (integer), see if current lexeme categor is
-- equal to it. If so, then advance to next lexeme & return true. If
-- not, then do not advance, return false.
-- Function init must be called before this function is called.
local function matchCat(c)
	if lexcat == c then
		advance()
		return true
	else
		return false
	end
end


-- Primary Function for Client Code

-- "local" statements for parsing functions
local parse_stmt_list
local parse_stmt
local parse_write_arg
local parse_expr
local parse_comp_expr
local parse_arith_expr
local parse_term
local parse_factor


-- parse
-- Given program, initialize parser and call parsing function for start
-- symbol. Returns pair of booleans & AST. First boolean indicates
-- successful parse or not. Second boolean indicates whetherthe parser 
-- reached the end of the input or not. AST is only valid if first
-- boolean is true.
function parseit.parse(prog)
	-- Initialization
	init(prog)
	-- Get results from parsing
	local good, ast = parse_stmt_list()  -- Parse start symbol
	local done = atEnd()

	-- And return them
	return good, done, ast
end



-- parse_stmt_list
-- Parsing function for nonterminal "stmt_list"
-- -- Function init must be called before this function is called.
function parse_stmt_list()
	local good, ast, newast

	ast = { STMT_LIST }
	while true do
		if lexstr ~= "write"
			and lexstr ~= "def"
			and lexstr ~= "if" 
			and lexstr ~= "while"
			and lexstr ~= "return"
			and lexcat ~= lexit.ID then
				return true, ast
		end

		good, newast = parse_stmt()

		if not good then
			return false, nil
		end
		table.insert(ast, newast)
	end
end


-- parse_stmt
-- Parsing function for nonterminal "statement".
-- Function init must be called before this function is called.
function parse_stmt()
	local good, ast1, ast2, savelex
	savelex = lexstr

	if matchString("write") then
		if not matchString("(") then
			return false, nil
		end

		good, ast1 = parse_write_arg()
		if not good then
			return false, nil
		end

		ast2 = { WRITE_STMT, ast1 }

		while matchString(",") do
			good, ast1 = parse_write_arg()
			if not good then
				return false, nil
			end

			table.insert(ast2, ast1)
		end

		if not matchString(")") then
			return false, nil
		end
		return true, ast2
	elseif matchString("def") then
		savelex = lexstr
		if not matchCat(lexit.ID) then
			return false, nil
		end
		if not matchString("(") then
			return false, nil
		end
		if not matchString(")") then
			return false, nil
		end


		good, ast1 = parse_stmt_list()
		if not good then
			return false, nil
		end

		ast2 = { FUNC_DEF, savelex, ast1 }

		if not matchString("end") then
			return false, nil
		end
		return true, ast2

    elseif matchString("if") then
        good, ast1 = parse_expr()
        if not good then
            return false, nil
        end
        good, ast3 = parse_stmt_list()
        if not good then
            return false, nil
        end
        ast2 = { IF_STMT, ast1, ast3 }

        while true do 
            if not matchString("elseif") then
                break
            end
            good, ast1 = parse_expr()
            if not good then            	
                return false, nil
            end
            good, ast3 = parse_stmt_list()

            if not good then
                return false, nil
            end

            table.insert(ast2, ast1)
            table.insert(ast2, ast3)
        end
        if matchString("else") then

            good, ast3 = parse_stmt_list()
            if not good then
                return false, nil
            end
            table.insert(ast2, ast3)
        end

        if not matchString("end") then
            return false, nil
        end

        return true, ast2
 
    elseif matchString("while") then
    	local ast3
        good, ast1 = parse_expr()

        if not good then
            return false, nil
        end

        good, ast3 = parse_stmt_list()
        if not good then
            return false, nil
        end

        ast2 = { WHILE_STMT, ast1, ast3 }
        
        if not matchString("end") then
            return false, nil
        end

        return true, ast2

    elseif matchString("return") then
        good, ast1 = parse_expr()
        if not good then
            return false, nil
        end
        ast2 = { RETURN_STMT, ast1 } 

        return true, ast2

    elseif matchCat(lexit.ID) then
        if matchString("(") then
        	if not matchString(")") then
            	return false, nil
            end
            ast2 = { FUNC_CALL, savelex }
            return true, ast2
        end
        if matchString("[") then
            good, ast1 = parse_expr()
            if not good then
                return false, nil
            end
            if not matchString("]") then
                return false, nil
            end
            ast3 = { ARRAY_VAR, savelex, ast1 }
        else
            ast3 = { SIMPLE_VAR, savelex, ast1 }
        end

        if matchString("=") then
            good, ast4 = parse_expr()
            if not good then                
                return false, nil
            end
            ast2 = { ASSN_STMT, ast3,ast4 }
            return true, ast2
        end
	end
end

function parse_write_arg()

    local good, ast1, ast2, savelex 
    savelex = lexstr
    if matchString("cr") then
    	return true, { CR_OUT, nil }
    elseif matchCat(lexit.STRLIT) then
        return true, { STRLIT_OUT, savelex }
    else 
        good, ast1 = parse_expr()
        if not good then
            return false, nil
        end

        return true, ast1 
    end
end

function parse_expr() 
    local good, ast1, ast2, savelex
    good, ast1 = parse_comp_expr()

    if not good then
        return false, nil
    end

    while true do 
        savelex = lexstr       
        if not matchString("&&") and not matchString("||") then
            break
        end
        good, ast2 = parse_comp_expr()
        if not good then
            return false, nil
        end
        ast1 = { { BIN_OP, savelex }, ast1, ast2 } 

    end
    return true, ast1
end

function parse_comp_expr()
    local good, ast1, ast2, savelex

    savelex = lexstr
    if matchString("!") then
        good, ast1 = parse_comp_expr()
        if not good then
            return false, nil
        end

        ast2 = { { UN_OP, savelex} , ast1}
        return true, ast2
    else
    	good, ast1 = parse_arith_expr()

        if not good then
            return false, nil
        end

        while true do
        savelex = lexstr
            if not matchString("==") and
                not matchString("!=") and
                not matchString("<") and
                not matchString("<=") and 
                not matchString(">") and 
                not matchString(">=") then
                    break
            end
            good, ast2 = parse_arith_expr()
            if not good then
                return false, nil
            end
            ast1 = { { BIN_OP, savelex }, ast1, ast2 }
        end
        return true, ast1
    end
end

function parse_arith_expr()

    local good, ast1, ast2, savelex
    good, ast1 = parse_term()

    if not good then
        return false, nil
    end

    while true do
        savelex = lexstr
        if not matchString("+") and
            not matchString("-") then
                break
        end

        good, ast2 = parse_term()
        if not good then

            return false, nil
        end
        ast1 = { { BIN_OP, savelex }, ast1, ast2, }

    end
    return true, ast1
end

function parse_term()

    local good, ast1, ast2, savelex
    good, ast1 = parse_factor()

    if not good then      
        return false, nil
    end

    while true do
        savelex = lexstr
        if not matchString("*") and
            not matchString("/") and
            not matchString("%") then
                break
        end
        good, ast2 = parse_factor()

        if not good then
            return false, nil
        end
        ast1 = { { BIN_OP, savelex }, ast1, ast2 }

    end
    return true, ast1
end

function parse_factor()
    local good, ast1, ast2, savelex
    savelex = lexstr
    if matchString("(") then
        good, ast1 = parse_expr()
        if not good then            
            return false, nil
        end

        if not matchString(")") then            
            return false, nil
        end
        return true, ast1

    elseif matchString("+") or matchString("-") then
        good, ast1 = parse_factor()
        if not good then            
            return false, nil
        end
        ast2 = { { UN_OP, savelex }, ast1 }
        return true, ast2
    elseif matchCat(lexit.NUMLIT) then
    	ast2 = { NUMLIT_VAL, savelex }
        return true, ast2
    elseif matchString("true") or matchString("false") then
        return true, { BOOLLIT_VAL, savelex }
    elseif matchString("readnum") then
        if matchString("(") then
            if not matchString(")") then
                return false, nil
            end
            return true, { READNUM_CALL, ast1 }
        end
        return false, nil
    elseif matchCat(lexit.ID) then
        if matchString("(") then
            if not matchString(")") then
                return false, nil
            end
            ast2 = { FUNC_CALL, savelex }
            return true, ast2
        end
        if matchString("[") then
            good, ast1 = parse_expr()
            if not good then
                return false, nil
            end
            if not matchString("]") then
                return false, nil
            end
            ast1 = { ARRAY_VAR, savelex, ast1 }
            return true, ast1
        end
        ast2 = { SIMPLE_VAR, savelex }
        return true, ast2
    else
        return false, nil
    end
end

-- Parsing Functions


return parseit