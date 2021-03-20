const fetch = require('node-fetch')

module.exports = function(req, res, next) {
	console.log(req)
	if (req.url.startsWith('/api/img/')) {
		url = req.url.replace('/api/img/', '')
		url = decodeURIComponent(url)
		fetch(url)
			.then(response => response.buffer())
			.then(buf => {
				res.setHeader('Access-Control-Allow-Credentials', true)
				res.setHeader('Access-Control-Allow-Origin', '*')
				res.setHeader('Content-Type', 'image/svg+xml')
				res.end(buf)
			})
	}
	else if (next) {
		next()
	}
}
