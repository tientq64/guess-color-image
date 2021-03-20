const fetch = require('node-fetch')

module.exports = function(req, res, next) {
	console.log(req.query.name)
	res.end(req.query.name)
}
