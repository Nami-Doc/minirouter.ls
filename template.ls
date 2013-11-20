# :: String -> DOMElement 
$ = document~getElementById

# get element html by id
# :: String -> String
tpl = $ >> (.innerHTML)

# K combinator,  λx.λy.x
k = (x) -> -> x

# pseudo-templating function
# type Template = String
# :: Template -> Object -> Maybe String -> Template
interpolate = (raw, variables, keypath || '') ->
	keypath and+= '.'
	for name, value of variables
		fullname = "#keypath#name"
		raw = if typeof! value is 'Object'
			interpolate raw, value, fullname
		else
			raw.replace "$#{fullname}$", value
	raw
