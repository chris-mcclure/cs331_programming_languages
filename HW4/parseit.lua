-- Chris McClure
-- CS331 HW4
-- Last Date Modified: 2/19/19
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
local function match(s)
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
	local good, ast = parse_expr()  -- Parse start symbol
	local done = atEnd()

	-- And return them
	return good, done, ast
end



-- Parsing Functions


return parseit