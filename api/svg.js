const fetch = require('node-fetch')

module.exports = async function(req, res) {
	let {id} = req.query
	url = `https://flaticon.com/svg/static/icons/svg/${id.slice(0, -3)}/${id}.svg`
	buf = await (await fetch(url)).buffer()
	res.setHeader('Access-Control-Allow-Credentials', true)
	res.setHeader('Access-Control-Allow-Origin', '*')
	res.setHeader('Content-Type', 'image/svg+xml')
	res.end(buf)
}
