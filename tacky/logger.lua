local _libs = {}
local _temp = (function()
	-- base is an internal version of core methods without any extensions or assertions.
	-- You should not use this unless you are building core libraries.

	-- Native methods in base should do the bare minimum: you should try to move as much
	-- as possible to Urn

	local pprint = require "tacky.pprint"

	local randCtr = 0
	return {
		['=='] = function(x, y) return x == y end,
		['~='] = function(x, y) return x ~= y end,
		['<'] = function(x, y) return x < y end,
		['<='] = function(x, y) return x <= y end,
		['>'] = function(x, y) return x > y end,
		['>='] = function(x, y) return x >= y end,

		['+'] = function(x, y) return x + y end,
		['-'] = function(x, y) return x - y end,
		['*'] = function(x, y) return x * y end,
		['/'] = function(x, y) return x / y end,
		['%'] = function(x, y) return x % y end,
		['^'] = function(x, y) return x ^ y end,
		['..'] = function(x, y) return x .. y end,

		['get-idx'] = rawget,
		['set-idx!'] = rawset,
		['remove-idx!'] = table.remove,
		['slice'] = function(xs, start, finish)
			if not finish then finish = xs.n end
			return { tag = "list", n = finish - start + 1, table.unpack(xs, start, finish) }
		end,

		['print!'] = print,
		['pretty'] = function (x) return pprint.tostring(x, pprint.nodeConfig) end,
		['error!'] = error,
		['type#'] = type,
		['empty-struct'] = function() return {} end,
		['format'] = string.format,
		['xpcall'] = xpcall,
		['traceback'] = debug.traceback,
		['require'] = require,
		['string->number'] = tonumber,
		['number->string'] = tostring,

		['gensym'] = function(name)
			if name then
				name = "_" .. tostring(name)
			else
				name = ""
			end

			randCtr = randCtr + 1
			return { tag = "symbol", contents = ("r_%d%s"):format(randCtr, name) }
		end,
	}

end)() 
for k, v in pairs(_temp) do _libs[k] = v end
local _temp = (function()
	return {
		byte    = string.byte,
		char    = string.char,
		concat  = table.concat,
		find    = function(text, pattern, offset, plaintext)
			local start, finish = string.find(text, pattern, offset, plaintext)
			if start then
				return { tag = "list", n = 2, start, finish }
			else
				return nil
			end
		end,
		format  = string.format,
		lower   = string.lower,
		reverse = string.reverse,
		rep     = string.rep,
		replace = string.gsub,
		sub     = string.sub,
		upper   = string.upper,

		['#s']   = string.len,
	}

end)() 
for k, v in pairs(_temp) do _libs[k] = v end

_3d3d_1 = _libs["=="]
_7e3d_1 = _libs["~="]
_3c_1 = _libs["<"]
_3c3d_1 = _libs["<="]
_3e_1 = _libs[">"]
_3e3d_1 = _libs[">="]
_2b_1 = _libs["+"]
_2d_1 = _libs["-"]
_25_1 = _libs["%"]
getIdx1 = _libs["get-idx"]
setIdx_21_1 = _libs["set-idx!"]
format1 = _libs["format"]
print_21_1 = _libs["print!"]
error_21_1 = _libs["error!"]
type_23_1 = _libs["type#"]
emptyStruct1 = _libs["empty-struct"]
number_2d3e_string1 = _libs["number->string"]
_23_1 = (function(xs1)
	return getIdx1(xs1, "n")
end);
car1 = (function(xs2)
	return getIdx1(xs2, 1)
end);
_21_1 = (function(expr1)
	if expr1 then
		return false
	else
		return true
	end
end);
key_3f_1 = (function(x6)
	return _3d3d_1(type1(x6), "key")
end);
type1 = (function(val1)
	local ty2
	ty2 = type_23_1(val1)
	if _3d3d_1(ty2, "table") then
		local tag1
		tag1 = getIdx1(val1, "tag")
		if tag1 then
			return tag1
		else
			return "table"
		end
	else
		return ty2
	end
end);
nth1 = (function(li4, idx1)
	local r_51
	r_51 = type1(li4)
	if _7e3d_1(r_51, "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_51), 2)
	else
	end
	local r_201
	r_201 = type1(idx1)
	if _7e3d_1(r_201, "number") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "idx", "number", r_201), 2)
	else
	end
	return getIdx1(li4, idx1)
end);
_23_2 = (function(li6)
	local r_81
	r_81 = type1(li6)
	if _7e3d_1(r_81, "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_81), 2)
	else
	end
	return _23_1(li6)
end);
car2 = (function(li3)
	return nth1(li3, 1)
end);
pushCdr_21_1 = (function(li9, val2)
	local r_111
	r_111 = type1(li9)
	if _7e3d_1(r_111, "list") then
		error_21_1(format1("bad argment %s (expected %s, got %s)", "li", "list", r_111), 2)
	else
	end
	local len1
	len1 = _2b_1(_23_1(li9), 1)
	setIdx_21_1(li9, "n", len1)
	setIdx_21_1(li9, len1, val2)
	return li9
end);
nil_3f_1 = (function(li5)
	return _3d3d_1(_23_2(li5), 0)
end);
cadr1 = (function(x1)
	return nth1(x1, 2)
end);
concat1 = _libs["concat"]
find1 = _libs["find"]
format2 = _libs["format"]
rep1 = _libs["rep"]
sub1 = _libs["sub"]
_23_s1 = _libs["#s"]
_2e2e_1 = (function(...)
	local args3 = table.pack(...) args3.tag = "list"
	return concat1(args3)
end);
split1 = (function(text1, pattern1, limit1)
	local out2, loop1, start3
	out2 = {tag = "list", n = 0}
	loop1 = true
	start3 = 1
	local r_751
	r_751 = nil
	r_751 = (function()
		if loop1 then
			local pos1
			pos1 = find1(text1, pattern1, start3)
			local _temp
			local r_761
			r_761 = _3d3d_1("nil", type_23_1(pos1))
			if r_761 then
				_temp = r_761
			else
				local r_771
				r_771 = limit1
				if r_771 then
					_temp = _3e3d_1(_23_1(out2), limit1)
				else
					_temp = r_771
				end
			end
			if _temp then
				loop1 = false
				pushCdr_21_1(out2, sub1(text1, start3, _23_s1(text1)))
				start3 = _2b_1(_23_s1(text1), 1)
			else
				pushCdr_21_1(out2, sub1(text1, start3, _2d_1(car1(pos1), 1)))
				start3 = _2b_1(cadr1(pos1), 1)
			end
			return r_751()
		else
		end
	end);
	r_751()
	return out2
end);
struct1 = (function(...)
	local keys3 = table.pack(...) keys3.tag = "list"
	if _3d3d_1(_25_1(_23_2(keys3), 1), 1) then
		error_21_1("Expected an even number of arguments to struct", 2)
	else
	end
	local contents1, out3
	contents1 = (function(key3)
		return sub1(getIdx1(key3, "contents"), 2)
	end);
	out3 = emptyStruct1()
	local r_731
	r_731 = _23_1(keys3)
	local r_741
	r_741 = 2
	local r_711
	r_711 = nil
	r_711 = (function(r_721)
		local _temp
		if _3c_1(0, 2) then
			_temp = _3c3d_1(r_721, r_731)
		else
			_temp = _3e3d_1(r_721, r_731)
		end
		if _temp then
			local i3
			i3 = r_721
			local key4, val3
			key4 = getIdx1(keys3, i3)
			val3 = getIdx1(keys3, _2b_1(1, i3))
			setIdx_21_1(out3, (function()
				if key_3f_1(key4) then
					return contents1(key4)
				else
					return key4
				end
			end)(), val3)
			return r_711(_2b_1(r_721, r_741))
		else
		end
	end);
	r_711(1)
	return out3
end);
fail1 = (function(msg1)
	return error_21_1(msg1, 0)
end);
_2f3d_1 = (function(x7, y1)
	return _7e3d_1(x7, y1)
end);
_3d_1 = (function(x8, y2)
	return _3d3d_1(x8, y2)
end);
succ1 = (function(x9)
	return _2b_1(1, x9)
end);
pred1 = (function(x10)
	return _2d_1(x10, 1)
end);
verbosity1 = struct1("value", 0)
setVerbosity_21_1 = (function(level1)
	return setIdx_21_1(verbosity1, "value", level1)
end);
showExplain1 = struct1("value", false)
setExplain_21_1 = (function(value2)
	return setIdx_21_1(showExplain1, "value", value2)
end);
colored1 = (function(col1, msg2)
	return _2e2e_1("\27[", col1, "m", msg2, "\27[0m")
end);
printError_21_1 = (function(msg3)
	local lines1
	lines1 = split1(msg3, "\n", 1)
	print_21_1(colored1(31, _2e2e_1("[ERROR] ", car2(lines1))))
	if cadr1(lines1) then
		return print_21_1(cadr1(lines1))
	else
	end
end);
printWarning_21_1 = (function(msg4)
	local lines2
	lines2 = split1(msg4, "\n", 1)
	print_21_1(colored1(33, _2e2e_1("[WARN] ", car2(lines2))))
	if cadr1(lines2) then
		return print_21_1(cadr1(lines2))
	else
	end
end);
printVerbose_21_1 = (function(msg5)
	if _3e_1(getIdx1(verbosity1, "value"), 0) then
		return print_21_1(_2e2e_1("[VERBOSE] ", msg5))
	else
	end
end);
printDebug_21_1 = (function(msg6)
	if _3e_1(getIdx1(verbosity1, "value"), 1) then
		return print_21_1(_2e2e_1("[DEBUG] ", msg6))
	else
	end
end);
formatPosition1 = (function(pos2)
	return _2e2e_1(getIdx1(pos2, "line"), ":", getIdx1(pos2, "column"))
end);
formatRange1 = (function(range1)
	if getIdx1(range1, "finish") then
		return format2("%s %s-%s", getIdx1(range1, "name"), formatPosition1(getIdx1(range1, "start")), formatPosition1(getIdx1(range1, "finish")))
	else
		return format2("%s %s", getIdx1(range1, "name"), formatPosition1(getIdx1(range1, "start")))
	end
end);
formatNode1 = (function(node1)
	local _temp
	local r_851
	r_851 = getIdx1(node1, "range")
	if r_851 then
		_temp = getIdx1(node1, "contents")
	else
		_temp = r_851
	end
	if _temp then
		return format2("%s (%q)", formatRange1(getIdx1(node1, "range")), getIdx1(node1, "contents"))
	elseif getIdx1(node1, "range") then
		return formatRange1(getIdx1(node1, "range"))
	elseif getIdx1(node1, "macro") then
		local macro1
		macro1 = getIdx1(node1, "macro")
		return format2("macro expansion of %s (%s)", getIdx1(getIdx1(macro1, "var"), "name"), formatNode1(getIdx1(macro1, "node")))
	else
		return "?"
	end
end);
getSource1 = (function(node2)
	local result1
	result1 = nil
	local r_861
	r_861 = nil
	r_861 = (function()
		local _temp
		local r_871
		r_871 = node2
		if r_871 then
			_temp = _21_1(result1)
		else
			_temp = r_871
		end
		if _temp then
			result1 = getIdx1(node2, "range")
			node2 = getIdx1(node2, "parent")
			return r_861()
		else
		end
	end);
	r_861()
	return result1
end);
putLines_21_1 = (function(range2, ...)
	local entries1 = table.pack(...) entries1.tag = "list"
	if nil_3f_1(entries1) then
		error_21_1("Positions cannot be empty")
	else
	end
	if _2f3d_1(_25_1(_23_2(entries1), 2), 0) then
		error_21_1(_2e2e_1("Positions must be a multiple of 2, is ", _23_2(entries1)))
	else
	end
	local previous1
	previous1 = -1
	local maxLine1
	maxLine1 = getIdx1(getIdx1(getIdx1(entries1, pred1(_23_2(entries1))), "start"), "line")
	local code1
	code1 = _2e2e_1("\27[92m %", _23_s1(number_2d3e_string1(maxLine1)), "s |\27[0m %s")
	local r_911
	r_911 = _23_2(entries1)
	local r_921
	r_921 = 2
	local r_891
	r_891 = nil
	r_891 = (function(r_901)
		local _temp
		if _3c_1(0, 2) then
			_temp = _3c3d_1(r_901, r_911)
		else
			_temp = _3e3d_1(r_901, r_911)
		end
		if _temp then
			local i4
			i4 = r_901
			local position1, message1
			position1 = getIdx1(entries1, i4)
			message1 = getIdx1(entries1, succ1(i4))
			local _temp
			local r_931
			r_931 = _2f3d_1(previous1, -1)
			if r_931 then
				_temp = _3e_1(_2d_1(getIdx1(getIdx1(position1, "start"), "line"), previous1), 2)
			else
				_temp = r_931
			end
			if _temp then
				print_21_1(" \27[92m...\27[0m")
			else
			end
			previous1 = getIdx1(getIdx1(position1, "start"), "line")
			print_21_1(format2(code1, number_2d3e_string1(getIdx1(getIdx1(position1, "start"), "line")), getIdx1(getIdx1(position1, "lines"), getIdx1(getIdx1(position1, "start"), "line"))))
			local pointer1
			if _21_1(range2) then
				pointer1 = "^"
			else
				local _temp
				local r_1001
				r_1001 = getIdx1(position1, "finish")
				if r_1001 then
					_temp = _3d_1(getIdx1(getIdx1(position1, "start"), "line"), getIdx1(getIdx1(position1, "finish"), "line"))
				else
					_temp = r_1001
				end
				if _temp then
					pointer1 = rep1("^", _2d_1(getIdx1(getIdx1(position1, "finish"), "column"), getIdx1(getIdx1(position1, "start"), "column"), -1))
				else
					pointer1 = "^..."
				end
			end
			print_21_1(format2(code1, "", _2e2e_1(rep1(" ", _2d_1(getIdx1(getIdx1(position1, "start"), "column"), 1)), pointer1, " ", message1)))
			return r_891(_2b_1(r_901, r_921))
		else
		end
	end);
	return r_891(1)
end);
putTrace_21_1 = (function(node3)
	local previous2
	previous2 = nil
	local r_881
	r_881 = nil
	r_881 = (function()
		if node3 then
			local formatted1
			formatted1 = formatNode1(node3)
			if _3d_1(previous2, nil) then
				print_21_1(colored1(96, _2e2e_1("  => ", formatted1)))
			elseif _2f3d_1(previous2, formatted1) then
				print_21_1(_2e2e_1("  in ", formatted1))
			else
				local _ = nil
			end
			previous2 = formatted1
			node3 = getIdx1(node3, "parent")
			return r_881()
		else
		end
	end);
	return r_881()
end);
putExplain_21_1 = (function(...)
	local lines3 = table.pack(...) lines3.tag = "list"
	if getIdx1(showExplain1, "value") then
		local r_951
		r_951 = lines3
		local r_981
		r_981 = _23_2(r_951)
		local r_991
		r_991 = 1
		local r_961
		r_961 = nil
		r_961 = (function(r_971)
			local _temp
			if _3c_1(0, 1) then
				_temp = _3c3d_1(r_971, r_981)
			else
				_temp = _3e3d_1(r_971, r_981)
			end
			if _temp then
				local r_941
				r_941 = r_971
				local line1
				line1 = getIdx1(r_951, r_941)
				print_21_1(_2e2e_1("  ", line1))
				return r_961(_2b_1(r_971, r_991))
			else
			end
		end);
		return r_961(1)
	else
	end
end);
errorPositions_21_1 = (function(node4, msg7)
	printError_21_1(msg7)
	putTrace_21_1(node4)
	local source1
	source1 = getSource1(node4)
	if source1 then
		putLines_21_1(true, source1, "")
	else
	end
	return fail1("An error occured")
end);
return struct1("formatPosition", formatPosition1, "formatRange", formatRange1, "formatNode", formatNode1, "putLines", putLines_21_1, "putTrace", putTrace_21_1, "putInfo", putExplain_21_1, "getSource", getSource1, "printWarning", printWarning_21_1, "printError", printError_21_1, "printVerbose", printVerbose_21_1, "printDebug", printDebug_21_1, "errorPositions", errorPositions_21_1, "setVerbosity", setVerbosity_21_1, "setExplain", setExplain_21_1)