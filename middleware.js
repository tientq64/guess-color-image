const fetch = require('node-fetch')

module.exports = function(req, res, next) {
	if (req.url.startsWith('/img/')) {
		url = req.url.replace('/img/', '')
		url = decodeURIComponent(url)
		fetch(url)
			.then(response => response.buffer())
			.then(buf => {
				res.setHeader('Content-Type', 'image/svg+xml')
				res.end(buf)
			})
	}
	else if (next) {
		next()
	}
}
