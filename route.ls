# --- pages
# newtype Properties = (Map String String)
# :: Map String (Properties -> String)
# @todo this needs to allow proper routes
Pages =
	__DEFAULT__: 'home'

	'home': proxy tpl 'home'

	'products': Controllers.Product.Index
	'product/:id': Controllers.Product.Show

# --- router
# type Route = String
# type URL = String
# :: Route -> URL -> Either Boolean Properties
# KILL ME
matches = (route, url) ->
	return [] if route is url

	route-parts = route / '/'
	url-parts = url / '/'
	if route-parts.length isnt url-parts.length
		return false

	params = {}
	for route-part, i in route-parts
		if route-part.0 is ':'
			params[route-part.slice 1] = url-parts[i]
		else if route-part isnt url-parts[i]
			return false
	params

matching-route = (routes, page) ->
	for route, ctrl of routes when matches route, page
		return [ctrl, that]
	[]

# wow
#      so much state
#  such imperative
#    much unhaskelly
dispatch = !->
	page = document.location.hash.slice 1 or Pages.__DEFAULT__

	[ctrl, params] = matching-route Pages, page

	switch typeof! ctrl
	| 'Object' 'Function'
		ctrl = ctrl params
	| 'String' => ctrl
	
	$ 'content' .innerHTML = ctrl
