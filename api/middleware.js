const fetch = require('node-fetch')

module.exports = function(req, res, next) {
	res.json(req)
}
